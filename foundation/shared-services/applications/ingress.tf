module "internal_ingress_controller" {
  source              = "../../../modules/kubernetes/ingress-controller"
  internal            = true
  name                = "internal"
  namespace           = kubernetes_namespace.toolchain_namespace.metadata.0.name
  default_certificate = module.internal_wildcard.cert_secret_name
}
