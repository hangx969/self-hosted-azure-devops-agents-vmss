#!/bin/bash

# This script is used to delete offline agents and agents with completed jobs, delete VM instances in Azure, and scale out new VMSS instances.
# It is designed to be run hourly by cronjob

########## Define Variables ##########
# yum install -y gawk
ORG_URL="https://dev.azure.com/<org_url>"
API_VERSION="7.1"

# Azure Resources
RG_NAME=${VMSS_RG_NAME}
VMSS_NAME=${VMSS_NAME}
KV_NAME="kv-self-hosted-agents-devops-cn3"
SECRET_NAME="china-self-hosted-agents-devops-pat"

# Login AzureChina with service principal
# The client_id and tenant_id are not set in this script, they are obtained from the pod's environment variables ingested from service account bounded workload identity
echo -e "Logging in to AzureChina with service principal..."
az account clear && az cloud set --name AzureChinaCloud && az login --service-principal --username "${AZURE_CLIENT_ID}" --tenant "${AZURE_TENANT_ID}" --federated-token "$(cat $AZURE_FEDERATED_TOKEN_FILE)"

# Get the PAT from keyvault
PAT_TOKEN=$(az keyvault secret show --vault-name $KV_NAME --name $SECRET_NAME --query value -o tsv)
# Encode PAT for use in the Authorization header, pay attention that : prefix is required
PAT_TOKEN_B64=$(printf "%s"":$PAT_TOKEN" | base64 -w0)

# Get devops pool id by pool name
POOL_NAME=${POOL_NAME}
POOL_ID=$(curl -s -H "Authorization: Basic $PAT_TOKEN_B64" "${ORG_URL}/_apis/distributedtask/pools?api-version=${API_VERSION}" | jq -r '.value[] | select(.name == "'$POOL_NAME'") | .id')

if [ -z "$POOL_ID" ]; then
    echo "Pool $POOL_NAME not found, please check the pool name and PAT token"
    exit 1
fi
echo -e "Agent pool $POOL_NAME found, Pool ID: $POOL_ID\n"


###### Function: Get VM instance id by agent computer name ######
function getInstanceID() {
    local RG_NAME=$1
    local VMSS_NAME=$2
    local TARGET_COMPUTER_NAME=$3

    # Get the map of instance ids to computer names for all instances in the VMSS
    local INSTANCES=$(az vmss list-instances --resource-group $RG_NAME --name $VMSS_NAME --query "[].{name:name, computerName:osProfile.computerName}" -o json)

    for INSTANCE in $(echo $INSTANCES | jq -c '.[]'); do
        local INSTANCE_NAME=$(echo $INSTANCE | jq -r '.name')
        local COMPUTER_NAME=$(echo $INSTANCE | jq -r '.computerName')

        if [ "$COMPUTER_NAME" == "$TARGET_COMPUTER_NAME" ]; then
            local INSTANCE_ID=$(echo $INSTANCE_NAME | awk -F'_' '{print $NF}')
            echo $INSTANCE_ID
            return
        fi
    done
    # If the agent is not found, return empty string
    echo ""
}


# Get a list of all agent ids in the pool
AGENT_IDS=$(curl -s -H "Authorization: Basic $PAT_TOKEN_B64" "${ORG_URL}/_apis/distributedtask/pools/${POOL_ID}/agents?api-version=${API_VERSION}" | jq -r '.value[].id')

# Loop through the agent ids and get the details for each agent
for AGENT_ID in $AGENT_IDS; do

    # Get info of each agent, including assignedRequest, lastCompletedRequest and capabilities
    AGENT_INFO=$(curl -s -H "Authorization: Basic $PAT_TOKEN_B64" "${ORG_URL}/_apis/distributedtask/pools/${POOL_ID}/agents/${AGENT_ID}?includeAssignedRequest=true&includeLastCompletedRequest=true&includeCapabilities=true&api-version=${API_VERSION}")

    # filter offline agents, delete them firstly to avoid conflict with newly created instances later
    if [ "$(echo "$AGENT_INFO" | jq -r '.status')" = "offline" ]; then
        # get computer name of the agent
        COMPUTER_NAME=$(echo "$AGENT_INFO" | jq -r '.systemCapabilities."Agent.ComputerName"')
        echo -e "Deleting offline agent $AGENT_ID, computer name: $COMPUTER_NAME"

        # delete agent from devops pool
        curl -s -X DELETE -H "Authorization: Basic $PAT_TOKEN_B64" "${ORG_URL}/_apis/distributedtask/pools/${POOL_ID}/agents/${AGENT_ID}?api-version=${API_VERSION}"

        # delete azure vm instance
        VM_INSTANCE_ID=$(getInstanceID "$RG_NAME" "$VMSS_NAME" "$COMPUTER_NAME")
        if [ -n "$VM_INSTANCE_ID" ]; then
            echo -e "Deleting VM instance in Azure, computer name: $COMPUTER_NAME, instance id: $VM_INSTANCE_ID\n"
            az vmss delete-instances --resource-group $RG_NAME --name $VMSS_NAME --instance-ids $VM_INSTANCE_ID
        else
            echo -e "VM instance not found for agent $AGENT_ID (computer name: $COMPUTER_NAME, instance id: $VM_INSTANCE_ID), skipping\n"
        fi

    # Agent： 1.online, 2.has compeleted jobs 3.idle. It can be deleted.
    # -n: if the string is not null --> true
    # -z: if the string is null --> true
    elif [ -n "$(echo "$AGENT_INFO" | jq -r '.lastCompletedRequest // empty')" ] && [ -z "$(echo "$AGENT_INFO" | jq -r '.assignedRequest // empty')" ]; then
        echo "Agent $AGENT_ID is online, has completed jobs, and is idle, can be removed"
        # delete agent from devops pool
        echo "Deleting agent $AGENT_ID from pool $POOL_ID"
        curl -s -X DELETE -H "Authorization: Basic $PAT_TOKEN_B64" "${ORG_URL}/_apis/distributedtask/pools/${POOL_ID}/agents/${AGENT_ID}?api-version=${API_VERSION}"

        # Get its computer name
        COMPUTER_NAME=$(echo "$AGENT_INFO" | jq -r '.systemCapabilities."Agent.ComputerName"')
        # delete azure vm instance
        VM_INSTANCE_ID=$(getInstanceID "$RG_NAME" "$VMSS_NAME" "$COMPUTER_NAME")

        if [ -n "$VM_INSTANCE_ID" ]; then
            echo -e "Deleting VM instance in Azure, computer name: $COMPUTER_NAME, instance id: $VM_INSTANCE_ID\n"
            az vmss delete-instances --resource-group $RG_NAME --name $VMSS_NAME --instance-ids $VM_INSTANCE_ID
        else
            echo -e "VM instance not found for agent $AGENT_ID (computer name: $COMPUTER_NAME, instance id: $VM_INSTANCE_ID)\n"
        fi

    else
        echo -e "Agent $AGENT_ID is fresh or currently busy, keep it\n"
    fi
done

# Get the number of remaining agents in the pool
AGENT_COUNTS=$(curl -s -H "Authorization: Basic $PAT_TOKEN_B64" "${ORG_URL}/_apis/distributedtask/pools/${POOL_ID}/agents?api-version=${API_VERSION}" | jq -r '.count')
echo -e "There are $AGENT_COUNTS agents remaining in pool $POOL_NAME\n"

# If current number of agents is less than expected, scale out the VMSS to the expected number

#### Option 1: Scale all at once ####
if [ $AGENT_COUNTS -lt ${EXPECTED_COUNT} ]; then
    echo -e "Scaling out VMSS $VMSS_NAME from $AGENT_COUNTS to $EXPECTED_COUNT instances\n"
    az vmss scale --resource-group $RG_NAME --name $VMSS_NAME --new-capacity $EXPECTED_COUNT --query "id" -o tsv
fi

#### Option 2: Scale one by one to avoid name conflicting in agent pool ####
# if [ $AGENT_COUNTS -lt ${EXPECTED_COUNT} ]; then
#     CURRENT_COUNT=$AGENT_COUNTS
#     echo -e "Scaling out VMSS $VMSS_NAME from $CURRENT_COUNT to ${EXPECTED_COUNT} instances\n"
#     while [ $CURRENT_COUNT -lt ${EXPECTED_COUNT} ]; do
#         NEW_COUNT=$((CURRENT_COUNT + 1))
#         echo -e "Scaling to $NEW_COUNT instances"
#         az vmss scale --resource-group $RG_NAME --name $VMSS_NAME --new-capacity $NEW_COUNT --query "id" -o tsv
#         sleep 5
#         CURRENT_COUNT=$NEW_COUNT
#         echo -e "Having Scaled to $NEW_COUNT instances\n"
#     done
# fi