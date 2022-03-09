resource "kubernetes_namespace" "github_runner_namespace" {
  metadata {
    name = "github-runners"
  }
}

data "azurerm_key_vault_secret" "github_pat" {
  name         = "runners-controller-pat"
  key_vault_id = var.key_vault_id
}

resource "kubernetes_secret" "github_pat" {
  metadata {
    name      = "github-runners-pat"
    namespace = kubernetes_namespace.github_runner_namespace.metadata.0.name
  }

  data = {
    github_token = data.azurerm_key_vault_secret.github_pat.value
  }

  type = "Opaque"
}

module "github_runner_controller" {
  source = "../../../modules/kubernetes/github-runners-controller"

  namespace            = kubernetes_namespace.github_runner_namespace.metadata.0.name
  github_org           = var.github_org
  ingress_domain       = var.dns_zone_name
  auth_pat_secret_name = kubernetes_secret.github_pat.metadata.0.name
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
