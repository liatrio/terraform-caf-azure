module "internal_wildcard" {
  depends_on = [
    module.cert_manager,
    module.cert_manager_issuer,
    module.cert_manager_pod_identity
  ]
  source = "../../../modules/kubernetes/certificates"

  name      = "internal-wildcard"
  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name
  domain    = "internal.${var.dns_zone_name}"

  issuer_name = var.issuer_name
}

module "internal_ingress_controller" {
  source              = "../../../modules/kubernetes/ingress-controller"
  internal            = "true"
  name                = "internal"
  namespace           = kubernetes_namespace.toolchain_namespace.metadata.0.name
  default_certificate = module.internal_wildcard.cert_secret_name
}
