output "azure_resource_group" {
  value = var.azure_resource_group
}

output "identity_client_id" {
  value = var.cert_mgr_dns_contributor_client_id
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
