module "internal_ingress_controller" {
  source    = "../../../modules/kubernetes/ingress-controller"
  name      = "internal"
  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name
}
