terraform {
  required_version = ">= 1.11.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.23.0"
    }
  }
  backend "azurerm" {
    environment = "china"
  }
}

provider "azurerm" {
  environment     = "china"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}