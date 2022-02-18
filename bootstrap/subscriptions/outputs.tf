output "connectivity_subscription_id" {
  value = azurerm_subscription.connectivity.subscription_id
}

output "management_subscription_id" {
  value = azurerm_subscription.management.subscription_id
}

output "identity_subscription_id" {
  value = azurerm_subscription.identity.subscription_id
}

output "shared_services_subscription_ids" {
  value = { for shared_service_name, azurerm_subscription in azurerm_subscription.shared_services : azurerm_subscription.id => shared_service_name }
}
