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
