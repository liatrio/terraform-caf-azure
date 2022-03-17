module "external_dns_pod_identity" {
  depends_on = [module.aad_pod_identity]
  source     = "../../../modules/kubernetes/aad-pod-identity-instance"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name

  identity_name        = "external-dns-pod-identity"
  identity_client_id   = var.external_dns_aad_pod_identity_client_id
  identity_resource_id = var.external_dns_aad_pod_identity_resource_id
}

module "external_dns_private" {
  source = "../../../modules/kubernetes/external-dns"

  pod_identity = module.external_dns_pod_identity.identity_name
  dns_provider = "azure-private-dns"
  domain_filters = [
    "${local.internal_dns_zone_name}"
  ]
  namespace                    = kubernetes_namespace.toolchain_namespace.metadata.0.name
  dns_zone_resource_group_name = var.dns_zone_resource_group_name
  // tenant_id                    = var.tenant_id
  tenant_id             = data.azurerm_client_config.current.tenant_id
  azure_subscription_id = var.azure_subscription_id
  release_name          = "external-dns-private"
}
