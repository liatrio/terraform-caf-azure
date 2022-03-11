locals {
  ingress_hostname = "${var.github_org}-webhook.${var.ingress_domain}"
  release_name     = "${var.github_org}-runner-controller"
}

resource "helm_release" "github_runner_controller" {
  name       = local.release_name
  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  version    = "0.16.1"
  namespace  = var.namespace
  wait       = true

  values = [
    templatefile("${path.module}/runner-controller-values.yaml.tpl", {
      secret_name : var.auth_pat_secret_name
      controller_replica_count : var.controller_replica_count
      ingress_hostname : local.ingress_hostname
      github_webhook_annotations : var.github_webhook_annotations
    })
  ]
}
