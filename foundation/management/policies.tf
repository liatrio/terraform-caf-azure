module "policy" {
  source = "../../modules/azure/policy-assignments"

  for_each = var.landing_zone_mg

  management_group_id = "${var.group_prefix}-${each.key}"
  policy_ids          = each.value.policy_ids
}
