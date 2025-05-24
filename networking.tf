# create subnets for dev and prod vmss
module "networking-vmss-dev" {
    source = "./modules/networking"
    subnet-vmss = {
    "name"                 = "snet-agents-dev",
    "address_prefixes"     = ["10.0.0.1/28"]
    }
}

module "networking-vmss-prod" {
    source = "./modules/networking"
    subnet-vmss = {
    "name"                 = "snet-agents-prod",
    "address_prefixes"     = ["10.0.0.16/28"]
    }
}

# create subnets for private endpoint
module "networking-vmss-pe" {
    source = "./modules/networking"
    subnet-vmss = {
    "name"                 = "snet-agents-pe",
    "address_prefixes"     = ["10.0.0.32/28"]
    }
}

# Create private endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault" {
    name                = "pe-${var.kv_name}-keyvault"
    location            = var.location
    resource_group_name = azurerm_key_vault.kv-vmss.resource_group_name
    subnet_id           = module.networking-vmss-pe.output-subnet-vmss.id

    private_service_connection {
        name                           = "pesc-${var.kv_name}-keyvault"
        private_connection_resource_id = azurerm_key_vault.kv-vmss.id
        is_manual_connection           = false
        subresource_names              = ["vault"]
    }

    lifecycle {
        ignore_changes = [private_dns_zone_group]
    }
    depends_on = [ azurerm_key_vault.kv-vmss ]
}

# Create private endpoint for storage account
resource "azurerm_private_endpoint" "pe-storage" {
    resource_group_name           = azurerm_storage_account.sa-vmss.resource_group_name
    location                      = azurerm_storage_account.sa-vmss.location
    name                          = "pe-${azurerm_storage_account.sa-vmss.name}-blob"
    custom_network_interface_name = "nic-${azurerm_storage_account.sa-vmss.name}-blob"
    subnet_id                     = module.networking-vmss-pe.output-subnet-vmss.id

    private_service_connection {
        name                           = "psc-${azurerm_storage_account.sa-vmss.name}-blob"
        is_manual_connection           = false
        private_connection_resource_id = azurerm_storage_account.sa-vmss.id
        subresource_names              = ["blob"]
    }

    lifecycle {
        ignore_changes = [private_dns_zone_group]
    }
    depends_on = [ azurerm_storage_account.sa-vmss ]
}