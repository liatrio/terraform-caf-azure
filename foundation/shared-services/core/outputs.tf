output "lz_resource_group_id" {
  value = azurerm_resource_group.lz_resource_group.id
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

output "cert_mgr_dns_contributor_client_id" {
  value = azurerm_user_assigned_identity.cert_mgr_dns_contributor.client_id
}
