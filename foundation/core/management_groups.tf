resource "azurerm_management_group" "foundation" {
  name         = var.group_prefix
  display_name = var.foundation_name
}

resource "azurerm_management_group" "platform" {
  name                       = "${var.group_prefix}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.foundation.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.group_prefix}-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.foundation.id
}

resource "azurerm_management_group" "dynamic" {
  for_each                   = var.landing_zone_mg
  name                       = "${var.group_prefix}-${each.key}"
  display_name               = each.value.display_name
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "shared_svc" {
  name                       = "${var.group_prefix}-shared-svc"
  display_name               = "Shared Services"
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
