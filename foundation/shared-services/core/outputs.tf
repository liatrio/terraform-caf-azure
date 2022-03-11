output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "shared_services_cluster_host" {
  value = module.aks.cluster_host
}

output "cluster_client_certificate" {
  value     = module.aks.cluster_client_certificate
  sensitive = true
}

output "cluster_client_key" {
  value     = module.aks.cluster_client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.aks.cluster_ca_certificate
  sensitive = true
}

output "kubelet_identity_client_id" {
  value = module.aks.kubelet_identity_client_id
}

output "aad_pod_identity_client_id" {
  value = azurerm_user_assigned_identity.cert_manager_pod_identity.client_id
}

# Resource Id Used for identity binding
output "aad_pod_identity_resource_id" {
  value = azurerm_user_assigned_identity.cert_manager_pod_identity.id
}

output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}
