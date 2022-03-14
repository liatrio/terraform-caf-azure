resource "azurerm_resource_group" "caf_connectivity" {
  provider = azurerm.connectivity
  name     = "${var.group_prefix}-connectivity"
  location = var.location
}

resource "azurerm_virtual_wan" "caf_vwan" {
  provider            = azurerm.connectivity
  name                = "${var.group_prefix}-vwan-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
}

resource "azurerm_virtual_hub" "caf_hub" {
  provider            = azurerm.connectivity
  name                = "${var.group_prefix}-hub-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
  virtual_wan_id      = azurerm_virtual_wan.caf_vwan.id
  address_prefix      = var.virtual_hub_address_cidr
}


