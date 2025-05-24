<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.
## Usage
Basic usage of this module is as follows:
```terraform
module "example" {
  	 source  = "<module-path>"
        
	 # Required variables
        	 subnet-vmss-id  = 
        
	 # Optional variables
        	 default_tags  = {}
        	 environment  = "dev"
        	 image_gallery  = {
  "gallery_name": "shared_image_gallery_cn3",
  "image_definition_name": "Ubuntu_2204_agent_gen1",
  "resource_group_name": "rg-shared-image-gallery-chinanorth3"
}
        	 kv-name  = "kv-agents"
        	 kv-secret  = "agents-secret"
        	 location  = "chinanorth3"
        	 rg-devopstools  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-devopstools-chinanorth3"
        	 sa-vmss-container  = "container-agents"
        	 sa-vmss-name  = "saagents"
        	 vmss  = {
  "count": 2,
  "image_version": "latest",
  "name": "vmss-agents",
  "pool_name": "pool_agents",
  "size": "Standard_D4ds_v5",
  "username": "lxadmin"
}
        	 vmss_resource_group_name  = "rg-agents"
}
```
## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_resource_group.rg-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.image-gallery-vmss-role-assignment-uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kv-vmss-role-assignment-uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sa-vmss-role-assignment-uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.uai-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_machine_scale_set_extension.extension-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_resource_group.rg-image-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_shared_image.image-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | value of default tags, e.g. owner, project, service, etc. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | value of environment tag, e.g. dev, prod | `string` | `"dev"` | no |
| <a name="input_image_gallery"></a> [image\_gallery](#input\_image\_gallery) | Image gallery parameters for vmss | <pre>object({<br/>    image_definition_name = string<br/>    gallery_name          = string<br/>    resource_group_name   = string<br/>  })</pre> | <pre>{<br/>  "gallery_name": "shared_image_gallery_cn3",<br/>  "image_definition_name": "Ubuntu_2204_agent_gen1",<br/>  "resource_group_name": "rg-shared-image-gallery-chinanorth3"<br/>}</pre> | no |
| <a name="input_kv-name"></a> [kv-name](#input\_kv-name) | Name of the key vault for vmss | `string` | `"kv-agents"` | no |
| <a name="input_kv-secret"></a> [kv-secret](#input\_kv-secret) | Name of the secret in the key vault for vmss | `string` | `"agents-secret"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where all resources should be created. | `string` | `"chinanorth3"` | no |
| <a name="input_rg-devopstools"></a> [rg-devopstools](#input\_rg-devopstools) | Scope of the role assignment for the vmss uai to access storage account and keyvault | `string` | `"/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-devopstools-chinanorth3"` | no |
| <a name="input_sa-vmss-container"></a> [sa-vmss-container](#input\_sa-vmss-container) | Name of the storage account container for vmss | `string` | `"container-agents"` | no |
| <a name="input_sa-vmss-name"></a> [sa-vmss-name](#input\_sa-vmss-name) | Name of the storage account for vmss | `string` | `"saagents"` | no |
| <a name="input_subnet-vmss-id"></a> [subnet-vmss-id](#input\_subnet-vmss-id) | Subnet id for vmss | `string` | n/a | yes |
| <a name="input_vmss"></a> [vmss](#input\_vmss) | VMSS configuration parameters | <pre>object({<br/>    name                  = string<br/>    size                  = string<br/>    username              = string<br/>    pool_name             = string<br/>    count                 = number<br/>    image_version         = string<br/>  })</pre> | <pre>{<br/>  "count": 2,<br/>  "image_version": "latest",<br/>  "name": "vmss-agents",<br/>  "pool_name": "pool_agents",<br/>  "size": "Standard_D4ds_v5",<br/>  "username": "lxadmin"<br/>}</pre> | no |
| <a name="input_vmss_resource_group_name"></a> [vmss\_resource\_group\_name](#input\_vmss\_resource\_group\_name) | The name of the resource group in which to create the vmss | `string` | `"rg-agents"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vmss_managed_identity_id"></a> [vmss\_managed\_identity\_id](#output\_vmss\_managed\_identity\_id) | The user assigned identity id of the VMSS |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->