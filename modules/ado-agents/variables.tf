variable "vmss_resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the vmss"
  default     = "rg-xxxx"
}

variable "location" {
  type        = string
  description = "The Azure Region where all resources should be created."
  default     = "chinanorth3"
}

variable "environment" {
  type        = string
  description = "value of environment tag, e.g. dev, prod"
  default     = "dev"
}

variable "default_tags" {
  type        = map(string)
  description = "value of default tags, e.g. owner, project, service, etc."
  default     = {}
}

variable "image_gallery" {
  description = "Image gallery parameters for vmss"
  type = object({
    image_definition_name = string
    gallery_name          = string
    resource_group_name   = string
  })
  default = {
    image_definition_name = "Ubuntu_2204_agent_gen1",
    gallery_name          = "xxx_shared_image_gallery_cn3",
    resource_group_name   = "rg-xxxxxx"
  }
}

variable "vmss" {
  description = "VMSS configuration parameters"
  type = object({
    name                  = string
    size                  = string
    username              = string
    pool_name             = string
    count                 = number
    image_version         = string
  })
  default = {
    name                   = "vmss-xxxxx", # Default name of the VMSS
    size                   = "Standard_D4ds_v5", # Default size of the VMSS
    username               = "xxxadmin", # Default username for the VMSS
    pool_name              = "xxxx", # Default name for the VMSS to register to azure devops agent pool
    count                  = 2,
    image_version          = "latest"
  }
}

variable "subnet-vmss-id" {
  type        = string
  description = "Subnet id for vmss"
}

# keyvault parameters
variable "kv-name" {
  type        = string
  description = "Name of the key vault for vmss"
  default     = "kv-xxxxx"
}

variable "kv-secret" {
  type        = string
  description = "Name of the secret in the key vault for vmss"
  default     = "XXXX-secret"
}

# storage parameters
variable "sa-vmss-name" {
  type        = string
  description = "Name of the storage account for vmss"
  default     = "sa-xxxxx"
}

variable "sa-vmss-container" {
  type        = string
  description = "Name of the storage account container for vmss"
  default     = "container-xxxxx"
}

variable "rg-devopstools" {
  type        = string
  description = "Scope of the role assignment for the vmss uai to access storage account and keyvault"
  default     = "/subscriptions/xxxxxx/resourceGroups/rg-xxxxxx"
}