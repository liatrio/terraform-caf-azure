locals {
  foundation_policy_sets    = ["/providers/Microsoft.Management/managementGroups/aac9fb06-16d1-43ae-9c85-6df179535e1e/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Encryption-CMK"]
  platform_policy_sets      = []
  landing_zones_policy_sets = ["/providers/Microsoft.Management/managementGroups/management_group_id/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Sql-Security", "/providers/Microsoft.Management/managementGroups/management_group_id/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"]
  shared_svc_policy_sets    = ["/providers/Microsoft.Management/managementGroups/management_group_id/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Sql-Security", "/providers/Microsoft.Management/managementGroups/management_group_id/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"]
}

module "foundation-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.foundation_policy_sets, var.foundation_policy_sets)
}

module "platform-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.platform_policy_sets, var.platform_policy_sets)
}

module "landing_zones-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.landing_zones_policy_sets, var.landing_zones_policy_sets)
}

module "shared_svc-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.shared_svc_policy_sets, var.shared_svc_policy_sets)
}

module "policy-sets-dynamic-mgs" {
  source = "../../modules/azure/policy-set-assignments-mg"

  for_each = var.landing_zone_mg

  target_management_group_id = "${var.group_prefix}-${each.value.display_name}"
  policy_set_ids             = each.value.policy_ids
}
