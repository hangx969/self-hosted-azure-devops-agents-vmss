resource "azurerm_key_vault" "kv-vmss" {
    name                          = var.kv_name
    location                      = var.location
    resource_group_name           = azurerm_resource_group.rg-devopstools.name
    tenant_id                     = var.tenant_id
    sku_name                      = "standard"
    soft_delete_retention_days    = 7
    purge_protection_enabled      = true
    public_network_access_enabled = false
    enable_rbac_authorization     = true

    network_acls {
        default_action             = "Deny"
        bypass                     = "AzureServices"
    }
}

