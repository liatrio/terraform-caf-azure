resource "azurerm_management_group" "foundation" {
  name         = var.group_prefix
  display_name = "Foundation" #this should be a var
}

resource "azurerm_management_group" "platform" {
  name                       = "${var.group_prefix}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.foundation.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = "${var.group_prefix}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    var.connectivity_id
  ]
}

resource "azurerm_management_group" "identity" {
  name                       = "${var.group_prefix}-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    var.identity_id
  ]
}

resource "azurerm_management_group" "management" {
  name                       = "${var.group_prefix}-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    var.management_id
  ]
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.group_prefix}-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.foundation.id
}

resource "azurerm_management_group" "corp" {
  name                       = "${var.group_prefix}-landing-zones"
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  name                       = "${var.group_prefix}-landing-zones"
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "sandboxes" {
  name                       = "${var.group_prefix}-sandboxes"
  display_name               = "Sandboxes"
  parent_management_group_id = azurerm_management_group.foundation.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "${var.group_prefix}-decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.foundation.id
}
