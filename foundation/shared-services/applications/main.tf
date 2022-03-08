resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    annotations = {
      name = var.toolchain_namespace
    }
    name = var.toolchain_namespace
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"
}


