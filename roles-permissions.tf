# Create a role assignment for the admin account and spn
resource "azurerm_role_assignment" "kv-vmss-role-assignment-admins" {
    count                = length(var.admin_principal_ids)
    scope                = azurerm_key_vault.kv-vmss.id
    role_definition_name = "Key Vault Administrator"
    principal_id         = var.admin_principal_ids[count.index]
    timeouts {
        create = "20m"
    }
    depends_on = [ azurerm_key_vault.kv-vmss ]
}

# Create a role assignment for the admin account and spn
resource "azurerm_role_assignment" "sa-vmss-role-assignment-admins" {
    count                = length(var.admin_principal_ids)
    scope                = azurerm_storage_account.sa-vmss.id
    role_definition_name = "Storage Blob Data Owner"
    principal_id         = var.admin_principal_ids[count.index]
    timeouts {
        create = "20m"
    }
    depends_on = [ azurerm_storage_account.sa-vmss ]
}

