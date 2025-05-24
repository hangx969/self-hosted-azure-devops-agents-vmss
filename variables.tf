# global variables
variable "tenant_id" {
  default = "12345678-1234-123456789012"
}

variable "subscription_id" {
  default = "12345678-1234-1234-1234-123456789012"
}

variable "location" {
  default = "chinanorth3"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "default_tags" {
  type = map(string)
  default = {}
}

variable "admin_principal_ids" {
    type    = list(string)
    default = ["123", "456"]
}

# key vault variables
variable "kv_name" {
    type    = string
    default = "kv-agents"
}

# storage account variables
variable "sa_name" {
  type    = string
  default = "saagents"
}

variable "container_name" {
  type    = string
  default = "devops-tools"
}