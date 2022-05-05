data "azurerm_private_dns_zone" "aks_private_dns_id" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.connectivity_resource_group_name
  provider            = azurerm.connectivity
}

data "azurerm_log_analytics_workspace" "management" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-management-${var.location}"
  resource_group_name = "rg-${var.prefix}-management-${var.location}"
}

data "azurerm_virtual_hub" "connectivity_hub" {
  count               = var.enable_virtual_hub_connection == true ? 1 : 0
  provider            = azurerm.connectivity
  name                = "${var.prefix}-hub-${var.location}"
  resource_group_name = "rg-${var.prefix}-connectivity-${var.location}"
}

data "azurerm_virtual_network" "target_virtual_network" {
  count               = var.enable_vnet_peering == true ? 1 : 0
  provider            = azurerm.connectivity
  name                = "${var.prefix}-vnet-hub-${var.location}"
  resource_group_name = "rg-${var.prefix}-connectivity-${var.location}"
}

data "azurerm_subscription" "current" {
}

data "azurerm_subscription" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_private_dns_zone" "k8_connectivity" {
  provider            = azurerm.connectivity
  name                = var.connectivity_k8_private_dns_zone_name
  resource_group_name = var.connectivity_resource_group_name
}

