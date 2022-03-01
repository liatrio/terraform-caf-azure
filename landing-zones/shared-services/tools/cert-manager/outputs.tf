# Client Id Used for identity binding
output "identity_client_id" {
  value = azurerm_user_assigned_identity.cert_mgr_dns_identity.client_id
}

# Resource Id Used for identity binding
output "identity_resource_id" {
  value = azurerm_user_assigned_identity.cert_mgr_dns_identity.id
}
