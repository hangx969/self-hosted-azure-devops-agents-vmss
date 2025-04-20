#!/bin/sh
# Parameters
# keyvault{1} secret{2} pool{3} agent_name{4} username{5}

echo "Logging: Received parameters ${1} ${2} ${3} ${4} ${5}"
az cloud set --name AzureChinaCloud
az login --identity

pat=`az keyvault secret show --name ${2} --vault-name ${1} --query "value"`
currdate=`date '+%Y%m%d%H%M%S'`
random=${4}${currdate}

echo "Logging: AgentName ${random}"
DEVOPS_AGENT=/devopsagent
sudo chown -R ${5} $DEVOPS_AGENT
cd $DEVOPS_AGENT

echo "Logging: Configuring agent"
su ${5} -c "$DEVOPS_AGENT/config.sh --unattended  --url https://dev.azure.com/<organization> --auth pat --token ${pat} --pool ${3} --agent ${random} --acceptTeeEula"
./svc.sh install ${5}
./svc.sh start