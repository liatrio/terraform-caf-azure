module "management" {
    source = "./management"

    company_name         = "Liatrio"
    group_prefix         = var.group_prefix
    connectivity_id      = data.azurerm_subscription.connectivity.subscription_id
    identity_id          = data.azurerm_subscription.identity.subscription_id
    management_id        = data.azurerm_subscription.management.subscription_id
}
