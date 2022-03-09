resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    name = "toolchain"
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"
}
