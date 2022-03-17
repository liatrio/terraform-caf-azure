locals {
  name = var.name == "" ? "ingress-nginx" : "ingress-nginx-${var.name}"
  extra_args = var.default_certificate == "" ? var.extra_args : merge(var.extra_args, {
    default-ssl-certificate = "${var.namespace}/${var.default_certificate}"
  })
}

resource "helm_release" "nginx_ingress" {
  name       = local.name
  namespace  = var.namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.18"

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      internal   = var.internal
      extra_args = local.extra_args
    })
  ]
}
