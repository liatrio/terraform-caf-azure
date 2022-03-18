resource "helm_release" "identity" {
  name  = (var.helm_name != null ? var.helm_name : "pod-id-${var.identity_name}")
  chart = "${path.module}/charts/identity"

  namespace = var.namespace

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      identity_name        = var.identity_name
      identity_resource_id = var.identity_resource_id
      identity_client_id   = var.identity_client_id
    })
  ]
}
