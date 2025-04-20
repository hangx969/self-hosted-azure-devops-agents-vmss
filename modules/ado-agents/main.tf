# import shared image definition
data "azurerm_shared_image" "image-vmss" {
  resource_group_name = var.image_gallery.resource_group_name
  gallery_name        = var.image_gallery.gallery_name
  name                = var.image_gallery.image_definition_name
}

# create new resource group for the VMSS
resource "azurerm_resource_group" "rg-vmss" {
  name     = "${var.vmss_resource_group_name}-${var.environment}"
  location = var.location
}

# create vmss
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  resource_group_name         = azurerm_resource_group.rg-vmss.name
  location                    = azurerm_resource_group.rg-vmss.location
  name                        = "${var.vmss.name}-${var.environment}"
  sku                         = var.vmss.size
  instances                   = var.vmss.count
  admin_username              = var.vmss.username
  single_placement_group      = false
  overprovision               = false
  upgrade_mode                = "Manual"
  platform_fault_domain_count = 1
  custom_data                 = base64encode(file("${path.module}/cloud-init/buildagents-cloud-init.yml"))
  source_image_id             = data.azurerm_shared_image.image-vmss.id

  scale_in {
    rule = "OldestVM"
  }

  admin_ssh_key {
    username   = var.vmss.username
    public_key = tls_private_key.ssh.public_key_openssh
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai-vmss.id]
  }

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-xxxx"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet-vmss-id
    }
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  depends_on = [azurerm_user_assigned_identity.uai-vmss]
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# create extension for VMSS
resource "azurerm_virtual_machine_scale_set_extension" "extension-vmss" {
  name                         = "register_agent"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.vmss.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.1"

  settings           = <<SETTINGS
    {
        "fileUris": ["https://${var.sa-vmss-name}.blob.core.chinacloudapi.cn/${var.sa-vmss-container}/install.sh"]
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "sh install.sh ${local.keyvault} ${local.secret} ${local.pool_name} ${local.vmss_name}  ${local.username} > ${local.log_file}",
      "managedIdentity" : {}
    }
  PROTECTED_SETTINGS
}
