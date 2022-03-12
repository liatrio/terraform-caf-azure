module "identity" {
  source = "./identity"

  group_prefix         = var.group_prefix
  identity_id          = data.azurerm_subscription.identity.subscription_id
  identity_policy_sets = var.identity_policy_sets
}
