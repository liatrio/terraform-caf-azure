module "external_dns_pod_identity" {
  depends_on = [module.aad_pod_identity]
  source     = "../../../modules/kubernetes/aad-pod-identity-instance"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name

  identity_name        = "external-dns-pod-identity"
  identity_client_id   = var.aad_pod_identity_client_id
  identity_resource_id = var.aad_pod_identity_resource_id
}

# module "external_dns_public" {
#   source = "../../../modules/tools/external-dns"

#   release_name  = "external-dns-public"
#   dns_provider  = "azure"
#   service_account_annotations = {
#     "eks.amazonaws.com/role-arn" = var.external_dns_public_service_account_arn
#   }
#   domain_filters = [
#     var.cluster_domain
#   ]
#   namespace       = module.system_namespace.name
#   aws_zone_type   = "public"
#   watch_services  = true
#   exclude_domains = [var.internal_cluster_domain]
# }

module "external_dns_private" {
  source = "../../../modules/kubernetes/external-dns"
  pod_identity = module.external_dns_pod_identity.identity_name
  dns_provider  = "azure"
  domain_filters = [
    var.internal_cluster_domain
  ]
  namespace      = kubernetes_namespace.toolchain_namespace.metadata.0.name
  watch_services = true

}
