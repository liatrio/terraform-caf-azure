resource "azurerm_management_group" "foundation" {
  name         = var.group_prefix
  display_name = "Foundation"
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
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  management_group_id = azurerm_management_group.connectivity.id
  subscription_id     = data.azurerm_subscription.connectivity.id
}

resource "azurerm_management_group" "identity" {
  name                       = "${var.group_prefix}-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group_subscription_association" "identity" {
  management_group_id = azurerm_management_group.identity.id
  subscription_id     = data.azurerm_subscription.identity.id
}

resource "azurerm_management_group" "management" {
  name                       = "${var.group_prefix}-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group_subscription_association" "management" {
  management_group_id = azurerm_management_group.management.id
  subscription_id     = data.azurerm_subscription.management.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.group_prefix}-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.foundation.id
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

resource "azurerm_management_group" "environments" {
  name                       = "${var.group_prefix}-environments"
  display_name               = "Environments"
  parent_management_group_id = azurerm_management_group.landing_zones.id
  subscription_ids           = var.environment_subscriptions
}

