resource "kubernetes_namespace" "github_runner_namespace" {
  metadata {
    name = "github-runners"
  }
}

module "github_runner_controller" {
  source = "../../../modules/kubernetes/github-runners-controller"

  namespace      = kubernetes_namespace.github_runner_namespace.metadata.0.name
  github_org     = var.github_org
  ingress_domain = var.dns_zone_name

}

module "github_runners" {
  for_each = var.github_runners

  source      = "../../../modules/kubernetes/github-runners"
  github_repo = each.value.github_repo
  github_org  = each.value.github_org
  namespace   = each.value.namespace
  image       = each.value.image
  labels      = each.value.labels

  depends_on = [module.github_runner_controller]
}
