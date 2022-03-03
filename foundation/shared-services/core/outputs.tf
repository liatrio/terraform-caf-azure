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

output "cert_manager_managed_identity_client_id" {
  value = azurerm_user_assigned_identity.cert_manager.client_id
}