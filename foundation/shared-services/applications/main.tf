resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    annotations = {
      name = var.namespace
    }
    name = var.namespace
  }
}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name
  pod_labels = [
    var.cert_manager_pod_labels
  ]
}

resource "time_sleep" "wait_for_cert_manager" {
  depends_on = [module.cert_manager]

  create_duration = "20s"
}

resource "helm_release" "aad_pod_identity_controller" {
  name             = "aad-pod-identity"
  namespace        = "kube-system"
  repository       = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart            = "aad-pod-identity"
  version          = "4.1.8"
  create_namespace = false
  #verify     = false

  values = [<<-EOF
  rbac:
    allowAccessToSecrets: false
  installCRDs: true
  nmi:
    allowNetworkPluginKubenet: false
  EOF
  ]
}

module "cert_manager_pod_identity" {
  depends_on = [
    helm_release.aad_pod_identity_controller
  ]
  source = "../../../modules/kubernetes/aad-pod-identity-instance"

  namespace        = "cert-manager"
  create_namespace = true

  identity_name        = "cert-manager-pod-identity"
  identity_client_id   = var.aad_pod_identity_client_id
  identity_resource_id = var.aad_pod_identity_resource_id
}

module "cert_manager_issuer" {
  source = "../../../modules/kubernetes/cert-manager-issuer"

  namespace                    = kubernetes_namespace.toolchain_namespace.metadata.0.name
  issuer_name                  = var.issuer_name
  issuer_server                = var.issuer_server
  issuer_email                 = var.issuer_email
  azure_subscription_id        = var.azure_subscription_id
  dns_zone_resource_group_name = var.dns_zone_resource_group_name
  dns_zone_name                = var.dns_zone_name

  depends_on = [
    time_sleep.wait_for_cert_manager,
  module.cert_manager_pod_identity]
}

module "cluster_wildcard" {
  source = "../../../modules/kubernetes/certificates"

  name      = "cluster-wildcard"
  namespace = var.namespace
  domain    = var.dns_zone_name

  issuer_name = var.issuer_name
}
