resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    annotations = {
      name = var.namespace
    }
    name = var.namespace
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"
}

module "cert_manager_pod_identity" {
  depends_on = [module.aad_pod_identity]
  source     = "../../../modules/kubernetes/aad-pod-identity-instance"

  namespace = kubernetes_namespace.toolchain_namespace.metadata.0.name

  identity_name        = "cert-manager-pod-identity"
  identity_client_id   = var.aad_pod_identity_client_id
  identity_resource_id = var.aad_pod_identity_resource_id
}
