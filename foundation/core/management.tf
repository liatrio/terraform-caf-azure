module "management" {
  source = "./management"

  company_name           = "Liatrio"
  group_prefix           = var.group_prefix
  management_id          = data.azurerm_subscription.management.subscription_id
  management_policy_sets = var.management_policy_sets
}
