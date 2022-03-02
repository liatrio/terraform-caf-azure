resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    annotations = {
      name = var.namespace
    }
    name = var.namespace
  }
}

module "cert_manager" {
  source = "../../../../modules/kubernetes/cert-manager"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name
}

resource "time_sleep" "wait_for_cert_manager" {
  depends_on = [module.cert_manager]

  create_duration = "20s"
}

module "cert_manager_issuer" {
  source = "../../../../modules/kubernetes/cert-manager-issuer"

  namespace                        = kubernetes_namespace.toolchain_namespace.metadata.0.name
  issuer_type                      = var.issuer_type
  issuer_name                      = var.issuer_name
  issuer_server                    = var.issuer_server
  issuer_email                     = var.issuer_email
  issuer_kind                      = var.issuer_kind
  acme_solver                      = var.acme_solver
  ca_secret                        = var.ca_secret
  azure_subscription_id            = var.azure_subscription_id
  azure_resource_group_name        = var.azure_resource_group_name
  dns_zone_name                    = var.dns_zone_name
  azure_managed_identity_client_id = var.azure_managed_identity_client_id

  depends_on = time_sleep.wait_for_cert_manager
}
