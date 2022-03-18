resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = var.namespace
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  timeout    = 120
  version    = "v1.7.1"
  wait       = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      namespace    = var.namespace
      pod_identity = var.pod_identity
    })
  ]
}
