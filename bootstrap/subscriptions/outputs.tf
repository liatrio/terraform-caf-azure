output "connectivity_subscription_id" {
  value = azurerm_subscription.connectivity.subscription_id
}

output "management_subscription_id" {
  value = azurerm_subscription.management.subscription_id
}

output "identity_subscription_id" {
  value = azurerm_subscription.identity.subscription_id
}