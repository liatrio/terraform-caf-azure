terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

module "aks-vnet" {
  source                   = "../../modules/aks-vnet"
  name                     = var.shared_service_name
  location                 = "southcentralus"
  vnet_address_range       = "10.137.0.0/23"
  aks_subnet_address_range = "10.137.0.0/24"
}

# module "aks" {
#   source = "../../modules/aks"

#   location       = var.location
#   name           = var.name
#   pool_name      = var.pool_name
#   node_count     = var.node_count
#   vm_size        = var.vm_size
#   vnet_subnet_id = module.aks-vnet.vnet_subnet_id
# }
