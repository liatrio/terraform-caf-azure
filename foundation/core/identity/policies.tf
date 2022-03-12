locals {
  identity_policy_sets = []
}

module "identity-policy-sets" {
  source                     = "../../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.identity_policy_sets, var.identity_policy_sets)
}
