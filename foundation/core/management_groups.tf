# Base management group for the CAF
resource "azurerm_management_group" "foundation" {
  name         = var.prefix
  display_name = var.foundation_name
}

# foundation/platform
resource "azurerm_management_group" "platform" {
  name                       = "${var.prefix}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/platform/connectivity
resource "azurerm_management_group" "connectivity" {
  provider                   = azurerm.connectivity
  name                       = "${var.prefix}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.connectivity.subscription_id
  ]
}

# foundation/platform/management
resource "azurerm_management_group" "management" {
  name                       = "${var.prefix}-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.management.subscription_id
  ]
}

# foundation/platform/identity
resource "azurerm_management_group" "identity" {
  name                       = "${var.prefix}-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.identity.subscription_id
  ]
}

# foundation/sandboxes
resource "azurerm_management_group" "sandboxes" {
  name                       = "${var.prefix}-sandboxes"
  display_name               = "Sandboxes"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/decommissioned
resource "azurerm_management_group" "decommissioned" {
  name                       = "${var.prefix}-decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/landing zones
resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.prefix}-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/landing zones/shared services
resource "azurerm_management_group" "shared_svc" {
  name                       = "${var.prefix}-shared-svc"
  display_name               = "Shared Services"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

# foundation/landing zones/*
resource "azurerm_management_group" "dynamic" {
  for_each                   = var.landing_zone_mg
  name                       = "${var.prefix}-${each.key}"
  display_name               = each.value.display_name
  parent_management_group_id = azurerm_management_group.landing_zones.id
}
