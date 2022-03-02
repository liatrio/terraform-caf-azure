module "cert-manager" {
  source = "../../../../modules/tools/cert-manager"

  namespace = var.namespace
}