<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.
## Usage
Basic usage of this module is as follows:
```terraform
module "example" {
  	 source  = "<module-path>"
        
	 # Optional variables
        	 location  = "chinanorth3"
        	 subnet-vmss  = {
  "address_prefixes": [
    "xxx"
  ],
  "name": "snet-xxx"
}
        	 vnet-vmss  = {
  "resource_group_name": "rg-xxx",
  "virtual_network_name": "vnet-xxx"
}
}
```
## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_subnet_comms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_telecom_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_unicom_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.subnet-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.bound-nsg-subnet-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet-vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"chinanorth3"` | no |
| <a name="input_subnet-vmss"></a> [subnet-vmss](#input\_subnet-vmss) | vmss subnet parameters | <pre>object({<br/>        name                 = string<br/>        address_prefixes     = list(string)<br/>    })</pre> | <pre>{<br/>  "address_prefixes": [<br/>    "xxx"<br/>  ],<br/>  "name": "snet-xxx"<br/>}</pre> | no |
| <a name="input_vnet-vmss"></a> [vnet-vmss](#input\_vnet-vmss) | vmss vnet parameters | <pre>object({<br/>        virtual_network_name = string<br/>        resource_group_name  = string<br/>    })</pre> | <pre>{<br/>  "resource_group_name": "rg-xxx",<br/>  "virtual_network_name": "vnet-xxx"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output-subnet-vmss"></a> [output-subnet-vmss](#output\_output-subnet-vmss) | The subnet object for the VMSS |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->