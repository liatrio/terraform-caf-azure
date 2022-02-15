terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.83"
      configuration_aliases = [
        azurerm.subscription_liatrio_dev
      ]
    }
  }
}

module "aks-vnet" {
  source = "../../modules/aks-vnet"

  providers = {
    azurerm = azurerm.subscription_liatrio_dev
  }
  resource_group_name      = var.resource_group_name
  location                 = var.location
  vnet_address_range       = var.vnet_address_range
  aks_subnet_address_range = var.aks_subnet_address_range
}

module "aks" {
  source = "../../modules/aks"

  providers = {
    azurerm = azurerm.subscription_liatrio_dev
  }
  resource_group_name      = "${var.prefix}-aks-landing-zone"
  location                 = var.location
  prefix                   = var.prefix
  cluster_name             = var.cluster_name
  pool_name                = var.pool_name
  node_count               = var.node_count
  vm_size                  = var.vm_size
  vnet_address_range       = var.vnet_address_range
  aks_subnet_address_range = var.aks_subnet_address_range
}
