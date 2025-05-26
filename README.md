# Self-Hosted VMSS Agents

## Project Background

Azure DevOps pipelines using Microsoft-hosted agents are unavailable in Azure China, requiring organizations to deploy self-hosted agents instead.

This project delivers a Terraform-based solution for deploying self-hosted Azure DevOps agents through Virtual Machine Scale Sets (VMSS) in Azure China. The implementation provides:

- Scalable agent infrastructure to meet dynamic CI/CD demands
- Cost optimization through efficient resource utilization
- Automated deployment following infrastructure-as-code principles

## Resources Created
The following resources are provisioned by this project:
- **Virtual Machine Scale Set (VMSS):** Hosts the self-hosted agents and ensures scalability.
- **Azure DevOps Agent Configuration:** Configures the agents to connect to your Azure DevOps organization.
- **Virtual Network (VNet):** Provides network isolation and connectivity for the VMSS.
- **Subnets:** Segments the VNet for better organization and security.
- **Key Vault:** Manages secrets and credentials securely.
- **Storage Account:** Stores logs and diagnostic data for the VMSS.

## Module Directory
The project is divided into the following modules, each with its own README file for detailed documentation:

- [VMSS Module](./modules/ado-agents/README.md): Provisions the Virtual Machine Scale Set and configures the self-hosted agents.
- [Networking Module](./modules/networking/README.md): Sets up the required networking resources.

Refer to each module's README for specific usage and configuration details.