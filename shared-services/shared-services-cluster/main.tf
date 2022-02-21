terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

module "aks_vnet" {
  source                   = "../../modules/aks-vnet"
  name                     = "shared-service1"
  location                 = "southcentralus"
  vnet_address_range       = "10.137.0.0/23"
  aks_subnet_address_range = "10.137.0.0/24"
}

module "aks" {
  source = "../../modules/aks"

  location       = var.location
  name           = var.name
  pool_name      = var.pool_name
  node_count     = var.node_count
  vm_size        = var.vm_size
  vnet_subnet_id = module.aks-vnet.vnet_subnet_id
}

data "azurerm_virtual_hub" "connectivity_hub" {
  name           = "${var.prefix}-hub-${var.location}"
  resource_group = "${var.prefix}-connectivity"
}

resource "azurerm_virtual_hub_connection" "aks_vnet_hub_connection" {
  name                      = "shared-services-connection"
  virtual_hub_id            = azurerm_virtual_hub.connectivity_hub.id
  remote_virtual_network_id = module.aks_vnet.vnet_id
}

