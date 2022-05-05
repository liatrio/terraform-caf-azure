# Base management group for the CAF
resource "azurerm_management_group" "foundation" {
  name         = var.prefix
  display_name = var.foundation_name
}

# foundation/platform
resource "azurerm_management_group" "platform" {
  name                       = "mg-${var.prefix}-platform-${var.environment}-${var.location}"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/platform/connectivity
resource "azurerm_management_group" "connectivity" {
  provider                   = azurerm.connectivity
  name                       = "mg-${var.prefix}-connectivity-${var.environment}-${var.location}"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.connectivity.subscription_id
  ]
}

# foundation/platform/management
resource "azurerm_management_group" "management" {
  name                       = "mg-${var.prefix}-management-${var.environment}-${var.location}"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.management.subscription_id
  ]
}

# foundation/platform/identity
resource "azurerm_management_group" "identity" {
  name                       = "mg-${var.prefix}-identity-${var.environment}-${var.location}"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.identity.subscription_id
  ]
}

# foundation/sandboxes
resource "azurerm_management_group" "sandboxes" {
  name                       = "mg-${var.prefix}-sandboxes-${var.environment}-${var.location}"
  display_name               = "Sandboxes"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/decommissioned
resource "azurerm_management_group" "decommissioned" {
  name                       = "mg-${var.prefix}-decommissioned-${var.environment}-${var.location}"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/landing zones
resource "azurerm_management_group" "landing_zones" {
  name                       = "mg-${var.prefix}-landing-zones-${var.environment}-${var.location}"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.foundation.id
}

# foundation/landing zones/shared services
resource "azurerm_management_group" "shared_svc" {
  name                       = "mg-${var.prefix}-shared-svc-${var.environment}-${var.location}"
  display_name               = "Shared Services"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

# foundation/landing zones/*
resource "azurerm_management_group" "dynamic" {
  for_each                   = var.landing_zone_mg
  name                       = "mg-${var.prefix}-${each.key}-${var.environment}-${var.location}"
  display_name               = each.value.display_name
  parent_management_group_id = azurerm_management_group.landing_zones.id
}
