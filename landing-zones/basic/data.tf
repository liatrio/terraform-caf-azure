data "azurerm_virtual_hub" "connectivity_hub" {
  count               = var.enable_virtual_hub_connection == true ? 1 : 0
  provider            = azurerm.connectivity
  name                = "vhub-${var.prefix}-core-${var.location}"
  resource_group_name = "rg-${var.prefix}-core-connectivity-${var.location}"
}

data "azurerm_virtual_network" "target_virtual_network" {
  count               = var.enable_vnet_peering == true ? 1 : 0
  provider            = azurerm.connectivity
  name                = "vnet-${var.prefix}-core-${var.location}"
  resource_group_name = "rg-${var.prefix}-core-connectivity-${var.location}"
}
