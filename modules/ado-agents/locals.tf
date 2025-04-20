locals {
  keyvault  = var.kv-name
  secret    = var.kv-secret
  vmss_name = "${var.vmss.name}-${var.environment}"
  pool_name = "${var.vmss.pool_name}-${var.environment}"
  log_file  = "/devopsagent/extension.log"
  username  = var.vmss.username
}