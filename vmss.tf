# create dev vmss
module "vmss-dev" {
    source = "./modules/ado-agents"
    environment              = "dev"
    default_tags             = var.default_tags
    subnet-vmss-id           = module.networking-vmss-dev.output-subnet-vmss.id
    rg-devopstools           = azurerm_resource_group.rg-devopstools.id
}

# create prod vmss
module "vmss-prod" {
    source = "./modules/ado-agents"
    environment              = "prod"
    default_tags             = var.default_tags
    subnet-vmss-id           = module.networking-vmss-prod.output-subnet-vmss.id
    rg-devopstools           = azurerm_resource_group.rg-devopstools.id
}