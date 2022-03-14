data "azurerm_management_group" "platform" {
  name = "${var.group_prefix}-platform"
}

resource "azurerm_management_group" "management" {
  name                       = "${var.group_prefix}-management"
  display_name               = "Management"
  parent_management_group_id = data.azurerm_management_group.platform.id
  subscription_ids = [
    data.azurerm_subscription.management.subscription_id
  ]
}

locals {
  management_policy_sets = []
}

module "management-policy-sets" {
  source                     = "../../modules/azure/policy-set-assignments-mg"
  target_management_group_id = var.group_prefix
  policy_set_ids             = concat(local.management_policy_sets, var.management_policy_sets)
}