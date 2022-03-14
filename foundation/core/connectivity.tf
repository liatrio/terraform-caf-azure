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

resource "azurerm_management_group" "connectivity" {
  provider                   = azurerm.connectivity
  name                       = "${var.group_prefix}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
  subscription_ids           = [
    data.azurerm_subscription.connectivity.subscription_id
  ]
}

locals {
  connectivity_policy_sets = [
    "/providers/Microsoft.Management/managementGroups/management_group_id/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"
  ]
}

module "connectivity-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.connectivity_policy_sets, var.connectivity_policy_sets)
}
