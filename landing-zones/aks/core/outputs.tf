output "resource_group_name" {
  value = azurerm_resource_group.lz_resource_group.name
}

output "resource_group_id" {
  value = azurerm_resource_group.lz_resource_group.id
}

output "aad_pod_identity_client_id" {
  value = azurerm_user_assigned_identity.cert_manager_pod_identity.client_id
}

# Resource Id Used for identity binding
output "aad_pod_identity_resource_id" {
  value = azurerm_user_assigned_identity.cert_manager_pod_identity.id
}

output "cluster_host" {
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

output "external_app" {
  value = var.external_app
}

output "external_dns_aad_pod_identity_client_id" {
  value = var.external_app ? azurerm_user_assigned_identity.external_dns_pod_identity[0].client_id : ""
}

output "external_dns_aad_pod_identity_resource_id" {
  value = var.external_app ? azurerm_user_assigned_identity.external_dns_pod_identity[0].id : ""
}

output "dns_zone_name" {
  value = var.external_app ? var.dns_zone_name : ""
}
