module "cert_manager_pod_identity" {
  depends_on = [module.aad_pod_identity]
  source     = "../../../modules/kubernetes/aad-pod-identity-instance"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name

  identity_name        = "cert-manager-pod-identity"
  identity_client_id   = var.aad_pod_identity_client_id
  identity_resource_id = var.aad_pod_identity_resource_id
}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  namespace    = kubernetes_namespace.toolchain_namespace.metadata.0.name
  pod_identity = module.cert_manager_pod_identity.identity_name
}



resource "time_sleep" "wait_for_cert_manager" {
  depends_on = [
    module.cert_manager,
    module.cert_manager_pod_identity
  ]

  create_duration = "20s"
}

module "external_issuer" {
  depends_on = [
    time_sleep.wait_for_cert_manager
  ]

  count = var.external_app ? 1 : 0

  source = "../../../modules/kubernetes/cert-manager-issuer"

  namespace             = kubernetes_namespace.toolchain_namespace.metadata.0.name
  issuer_name           = "external-issuer"
  issuer_server         = var.issuer_server
  issuer_email          = var.issuer_email
  azure_subscription_id = var.azure_subscription_id
  resource_group_name   = var.dns_zone_resource_group_name
  dns_zone_name         = var.dns_zone_name
}

module "external_wildcard" {
  source = "../../../modules/kubernetes/certificates"

  count = var.external_app ? 1 : 0

  name      = "external-wildcard"
  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name
  domain    = var.dns_zone_name

  issuer_name = module.external_issuer[0].issuer_name
}
