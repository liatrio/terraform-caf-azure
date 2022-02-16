terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

resource "azurerm_resource_group" "caf_connectivity" {
  name     = "${var.prefix}-connectivity"
  location = var.location
}

resource "azurerm_virtual_wan" "caf_vwan" {
  name                = "${var.prefix}-vwan-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
}

resource "azurerm_virtual_hub" "caf_hub" {
  name                = "${var.prefix}-hub-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
  virtual_wan_id      = azurerm_virtual_wan.caf_vwan.id
  address_prefix      = var.vhub_subnet_cidr
}
