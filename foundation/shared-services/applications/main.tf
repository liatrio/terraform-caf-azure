resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    name = "toolchain"
  }
}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name
}

resource "time_sleep" "wait_for_cert_manager" {
  depends_on = [module.cert_manager]

  create_duration = "20s"
}

module "cert_manager_issuer" {
  source = "../../../modules/kubernetes/cert-manager-issuer"

  namespace                        = kubernetes_namespace.toolchain_namespace.metadata.0.name
  issuer_name                      = var.issuer_name
  issuer_server                    = var.issuer_server
  issuer_email                     = var.issuer_email
  azure_subscription_id            = var.azure_subscription_id
  azure_resource_group_name        = var.azure_resource_group_name
  dns_zone_name                    = var.dns_zone_name
  azure_managed_identity_client_id = var.azure_managed_identity_client_id

  depends_on = [time_sleep.wait_for_cert_manager]
}

module "github_runner_controller" {
  source = "../../../modules/kubernetes/github-runners-controller"

  namespace      = var.github_runner_namespace
  github_org     = var.github_org
  ingress_domain = var.dns_zone_name

  // github_webhook_annotations  = 
  // controller_replica_count    = 
}


