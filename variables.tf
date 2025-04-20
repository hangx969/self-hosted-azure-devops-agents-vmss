# global variables
variable "tenant_id" {
  default = "xxxx"
}

variable "subscription_id" {
  default = "xxxx"
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
    default = ["xxx", "xxx"]
}

# key vault variables
variable "kv_name" {
    type    = string
    default = "kv-xxxx"
}

# storage account variables
variable "sa_name" {
  type    = string
  default = "saxxxx"
}

variable "container_name" {
  type    = string
  default = "devops-tools"
}