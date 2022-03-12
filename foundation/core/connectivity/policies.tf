locals {
  connectivity_policy_sets = [
    "/providers/Microsoft.Management/managementGroups/management_group_id/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"
  ]
}

module "connectivity-policy-sets" {
  source                     = "../../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.connectivity_policy_sets, var.connectivity_policy_sets)
}
