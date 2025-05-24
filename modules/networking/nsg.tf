# Create nsg rules
resource "azurerm_network_security_rule" "allow_subnet_comms" {
    network_security_group_name = azurerm_network_security_group.nsg-subnet.name
    resource_group_name         = azurerm_subnet.subnet-vmss.resource_group_name
    name                        = "allow_subnet_comms"
    direction                   = "Inbound"
    access                      = "Allow"
    priority                    = 100
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = azurerm_subnet.subnet-vmss.address_prefixes[0]
    destination_address_prefix  = azurerm_subnet.subnet-vmss.address_prefixes[0]
}

resource "azurerm_network_security_rule" "allow_telecom_ip" {
    network_security_group_name = azurerm_network_security_group.nsg-subnet.name
    resource_group_name         = azurerm_subnet.subnet-vmss.resource_group_name
    name                        = "AllowIpSSHInbound"
    direction                   = "Inbound"
    access                      = "Allow"
    priority                    = 200
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "10.0.0.0/8"
    destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "allow_unicom_ip" {
    network_security_group_name = azurerm_network_security_group.nsg-subnet.name
    resource_group_name         = azurerm_subnet.subnet-vmss.resource_group_name
    name                        = "AllowIpSSHInbound2"
    direction                   = "Inbound"
    access                      = "Allow"
    priority                    = 300
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "10.0.0.0/8"
    destination_address_prefix  = "*"
}

# Create nsg
resource "azurerm_network_security_group" "nsg-subnet" {
    name                = "nsg-${azurerm_subnet.subnet-vmss.name}"
    location            = var.location
    resource_group_name = azurerm_subnet.subnet-vmss.resource_group_name
}

# Bound nsg to vmss subnet
resource "azurerm_subnet_network_security_group_association" "bound-nsg-subnet-vmss" {
    subnet_id                 = azurerm_subnet.subnet-vmss.id
    network_security_group_id = azurerm_network_security_group.nsg-subnet.id
}