locals {
  policy_set_location = "/providers/Microsoft.Management/managementGroups/${data.azurerm_client_config.default.tenant_id}/providers/Microsoft.Authorization/policySetDefinitions"

  foundation_policy_sets = [
    "${local.policy_set_location}/Enforce-Encryption-CMK"
  ]

  platform_policy_sets = []

  landing_zones_policy_sets = [
    "${local.policy_set_location}/Deny-PublicPaaSEndpoints"
  ]

  shared_svc_policy_sets = [
    "${local.policy_set_location}/Deny-PublicPaaSEndpoints"
  ]

  connectivity_policy_sets = [
    "${local.policy_set_location}/Deny-PublicPaaSEndpoints"
  ]

  management_policy_sets = []

  identity_policy_sets = []
}

module "foundation-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.foundation.id
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.foundation_policy_sets, var.foundation_policy_sets) : var.foundation_policy_sets
}

module "platform-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.platform.id
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.platform_policy_sets, var.platform_policy_sets) : var.platform_policy_sets
}

module "landing_zones-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.landing_zones.id
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.landing_zones_policy_sets, var.landing_zones_policy_sets) : var.landing_zones_policy_sets
}

module "shared_svc-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.shared_svc.id
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.shared_svc_policy_sets, var.shared_svc_policy_sets) : var.shared_svc_policy_sets
}

module "policy-sets-dynamic-mgs" {
  source = "../../modules/azure/policy-set-assignments-mg"

  for_each = azurerm_management_group.dynamic

  target_management_group_id = each.value.id
  policy_set_ids             = var.landing_zone_mg[each.key].policy_ids
}

module "connectivity-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.connectivity.id
  policy_set_ids             = concat(local.connectivity_policy_sets, var.connectivity_policy_sets)
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.connectivity_policy_sets, var.connectivity_policy_sets) : var.connectivity_policy_sets
}

module "management-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.management.id
  policy_set_ids             = concat(local.management_policy_sets, var.management_policy_sets)
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.management_policy_sets, var.management_policy_sets) : var.management_policy_sets
}

module "identity-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = azurerm_management_group.identity.id
  policy_set_ids             = concat(local.identity_policy_sets, var.identity_policy_sets)
  policy_set_ids             = var.default_policies_enabled == true ? concat(local.identity_policy_sets, var.identity_policy_sets) : var.identity_policy_sets
}
