variable "vnet-vmss" {
    description = "vmss vnet parameters"
    type = object({
        virtual_network_name = string
        resource_group_name  = string
    })
    default = {
        virtual_network_name = "vnet-xxx",
        resource_group_name  = "rg-xxx"
    }
}

variable "subnet-vmss" {
    description = "vmss subnet parameters"
    type = object({
        name                 = string
        address_prefixes     = list(string)
    })
    default = {
        name                 = "snet-xxx",
        address_prefixes     = ["xxx"]
    }
}

variable "location" {
    type        = string
    default     = "chinanorth3"
}