# create user assigned identity for vmss
resource "azurerm_user_assigned_identity" "uai-vmss" {
    location            = var.location
    name                = "uai-agents-${var.environment}"
    resource_group_name = azurerm_resource_group.rg-vmss.name
}

# Create a role assignment for the vmss uai to access the storage account
resource "azurerm_role_assignment" "sa-vmss-role-assignment-uai" {
    scope                = var.rg-devopstools
    role_definition_name = "Storage Blob Data Reader"
    principal_id         = azurerm_user_assigned_identity.uai-vmss.principal_id
    timeouts {
        create = "20m"
    }
}

# Create a role assignment for the vmss uai to access the keyvault
resource "azurerm_role_assignment" "kv-vmss-role-assignment-uai" {
    scope                = var.rg-devopstools
    role_definition_name = "Key Vault Secrets User"
    principal_id         = azurerm_user_assigned_identity.uai-vmss.principal_id
    timeouts {
        create = "20m"
    }
}

# Create a role assignment for the vmss uai to access the image gallery
data "azurerm_resource_group" "rg-image-vmss" {
    name = var.image_gallery.resource_group_name
}

resource "azurerm_role_assignment" "image-gallery-vmss-role-assignment-uai" {
    scope                = data.azurerm_resource_group.rg-image-vmss.id
    role_definition_name = "Compute Gallery Image Reader"
    principal_id         = azurerm_user_assigned_identity.uai-vmss.principal_id
    timeouts {
        create = "20m"
    }
}