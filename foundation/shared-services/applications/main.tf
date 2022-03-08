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
