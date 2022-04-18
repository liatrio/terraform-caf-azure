data "azurerm_key_vault" "ss_kv" {
  provider            = azurerm.shared_services
  name                = var.shared_services_keyvault
  resource_group_name = var.shared_services_resource_group
}

data "azurerm_resource_group" "vnet_rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "snet" {
  name                 = "service-endpoints"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
}

data "azurerm_private_dns_zone" "privatelink_mysql_dns_zone" {
  provider            = azurerm.connectivity
  name                = var.privatelink_mysql_dns_zone
  resource_group_name = var.connectivity_resource_group_name
}
