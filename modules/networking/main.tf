# import existing vnet for vmss to use
data "azurerm_virtual_network" "vnet-vmss" {
    resource_group_name = var.vnet-vmss.resource_group_name
    name                = var.vnet-vmss.virtual_network_name
}

# create subnet for vmss
resource "azurerm_subnet" "subnet-vmss" {
    name                 = var.subnet-vmss.name
    resource_group_name  = var.vnet-vmss.resource_group_name
    virtual_network_name = data.azurerm_virtual_network.vnet-vmss.name
    address_prefixes     = var.subnet-vmss.address_prefixes
}