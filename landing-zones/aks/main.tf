terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

module "aks-vnet" {
  source = "../../modules/aks-vnet"

  name                     = var.name
  location                 = var.location
  vnet_address_range       = var.vnet_address_range
  aks_subnet_address_range = var.aks_subnet_address_range
}

module "aks" {
  source = "../../modules/aks"

  location           = var.location
  name               = var.name
  pool_name          = var.pool_name
  node_count         = var.node_count
  vm_size            = var.vm_size
  vnet_subnet_id     = module.aks-vnet.vnet_subnet_id
  kubernetes_version = var.kubernetes_version
}

data "azurerm_virtual_hub" "connectivity_hub" {
  provider            = azurerm.connectivity
  # name                = "${var.prefix}-hub-${var.location}"
  name                = "${var.prefix}-hub-${var.connectivity_hub_location}"
  resource_group_name = "${var.prefix}-connectivity"
}

resource "azurerm_virtual_hub_connection" "aks_vnet_hub_connection" {
  provider                  = azurerm.connectivity
  name                      = "${var.name}-connection"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub.id
  remote_virtual_network_id = module.aks-vnet.vnet_id
}
