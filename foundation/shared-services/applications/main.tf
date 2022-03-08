resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    name = "toolchain"
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"
}

module "github_runner_controller" {
  source = "../../../modules/kubernetes/github-runners-controller"

  namespace      = var.github_runner_namespace
  github_org     = var.github_org
  ingress_domain = var.dns_zone_name

  // github_webhook_annotations  = 
  // controller_replica_count    = 
}


