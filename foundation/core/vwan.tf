resource "azurerm_resource_group" "caf_connectivity" {
  provider = azurerm.connectivity
  name     = "${var.prefix}-connectivity"
  location = var.location
}

resource "azurerm_virtual_wan" "caf_vwan" {
  provider            = azurerm.connectivity
  name                = "${var.prefix}-vwan-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
}

resource "azurerm_virtual_hub" "caf_hub" {
  provider            = azurerm.connectivity
  name                = "${var.prefix}-hub-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
  virtual_wan_id      = azurerm_virtual_wan.caf_vwan.id
  address_prefix      = var.virtual_hub_address_cidr
}

resource "azurerm_firewall" "firewall" {
  provider          = azurerm.connectivity
  name              = "afw-${var.prefix}-${azurerm_resource_group.caf_connectivity.location}"
  location          = var.location
  sku_name          = var.firewall_sku
  threat_intel_mode = ""
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.caf_hub.id
  }

  resource_group_name = azurerm_resource_group.caf_connectivity.name
}
