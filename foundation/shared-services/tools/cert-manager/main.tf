module "cert_manager" {
  source = "../../../../modules/tools/cert-manager"

  namespace = var.namespace
}
