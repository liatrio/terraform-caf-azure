locals {
  management_policy_sets = []
}

module "management-policy-sets" {
  source                     = "../../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.management_policy_sets, var.management_policy_sets)
}
