output "vmss_managed_identity_id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.identity.0.principal_id
  description = "The user assigned identity id of the VMSS"
}