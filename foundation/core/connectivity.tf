#module "connectivity" {
#  providers = {
#    azurerm              = azurerm.connectivity
#    azurerm.connectivity = azurerm.connectivity
#  }
#  source                               = "./connectivity"
#  location                             = var.location
#  virtual_hub_address_cidr             = var.virtual_hub_address_cidr
#  vpn_client_pool_address_cidr         = var.vpn_client_pool_address_cidr
#  connectivity_apps_address_cidr       = var.connectivity_apps_address_cidr
#  tenant_id                            = var.tenant_id
#  prefix                               = var.group_prefix
#  vpn_service_principal_application_id = var.vpn_service_principal_application_id
#  root_dns_zone                        = var.root_dns_zone
#  root_dns_tags                        = var.root_dns_tags
#  group_prefix                         = var.group_prefix
#  connectivity_id                      = data.azurerm_subscription.connectivity.subscription_id
#  connectivity_policy_sets             = var.connectivity_policy_sets
#}


resource "azurerm_resource_group" "caf_connectivity" {
  name     = "${var.group_prefix}-connectivity"
  location = var.location
}

resource "azurerm_virtual_wan" "caf_vwan" {
  name                = "${var.group_prefix}-vwan-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
}

resource "azurerm_virtual_hub" "caf_hub" {
  name                = "${var.group_prefix}-hub-${azurerm_resource_group.caf_connectivity.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
  virtual_wan_id      = azurerm_virtual_wan.caf_vwan.id
  address_prefix      = var.virtual_hub_address_cidr
}

data "azurerm_management_group" "platform" {
  name = "${var.group_prefix}-platform"
}

resource "azurerm_management_group" "connectivity" {
  name                       = "${var.group_prefix}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = data.azurerm_management_group.platform.id
  subscription_ids = [
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
