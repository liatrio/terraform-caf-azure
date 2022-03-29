data "azurerm_key_vault" "shrdsvcs_kv" {
  provider            = azurerm.shared_services
  name                = var.shrdsvcs_kv
  resource_group_name = var.shrdsvcs_rg
}

data "azurerm_resource_group" "vnet_rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.location
}

data "azurerm_subnet" "snet" {
  name                 = "service-endpoints"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
}
