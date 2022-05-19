module "external_ingress_controller" {
  source = "../../../modules/kubernetes/ingress-controller"

  count = var.external_app ? 1 : 0

  name                = "external"
  internal            = false
  namespace           = kubernetes_namespace.toolchain_namespace.metadata.0.name
  ingress_class       = "nginx"
  default_certificate = module.external_wildcard[0].cert_secret_name
}

module "internal_ingress_controller" {
  source              = "../../../modules/kubernetes/ingress-controller"
  internal            = true
  name                = "internal"
  namespace           = kubernetes_namespace.toolchain_namespace.metadata.0.name
  default_certificate = module.internal_wildcard.cert_secret_name
  ingress_class       = "nginx-internal"
}
