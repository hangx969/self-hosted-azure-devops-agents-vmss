variable "vnet-vmss" {
    description = "vmss vnet parameters"
    type = object({
        virtual_network_name = string
        resource_group_name  = string
    })
    default = {
        virtual_network_name = "vnet-agents",
        resource_group_name  = "rg-agents"
    }
}

variable "subnet-vmss" {
    description = "vmss subnet parameters"
    type = object({
        name                 = string
        address_prefixes     = list(string)
    })
    default = {
        name                 = "snet-agents",
        address_prefixes     = ["10.0.0.0/24"]
    }
}

variable "location" {
    type        = string
    default     = "chinanorth3"
}