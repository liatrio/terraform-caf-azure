data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {
}

data "azurerm_subscription" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_private_dns_zone" "aks_private_dns_id" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.connectivity_resource_group_name
  provider            = azurerm.connectivity
}

data "azurerm_log_analytics_workspace" "management" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-core-management-${var.location}"
  resource_group_name = "rg-${var.prefix}-core-management-${var.location}"
}

data "azurerm_virtual_hub" "connectivity_hub" {
  provider            = azurerm.connectivity
  name                = "vhub-${var.prefix}-core-${var.location}"
  resource_group_name = "rg-${var.prefix}-core-connectivity-${var.location}"
}

data "azurerm_virtual_network" "connectivity_vnet" {
  provider            = azurerm.connectivity
  name                = "vnet-core-connectivity-apps-${var.location}"
  resource_group_name = var.connectivity_resource_group_name
}

data "azurerm_private_dns_zone" "key_vault" {
  provider            = azurerm.connectivity
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.connectivity_resource_group_name
}
