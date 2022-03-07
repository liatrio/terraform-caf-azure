resource "helm_release" "identity" {
  name  = (var.helm_name != null ? var.helm_name : "pod-id-${var.identity_name}")
  chart = "${path.module}/charts/identity"

  namespace = var.namespace

  values = [<<-EOF
  azureIdentity:
    name: "${var.identity_name}"
    behavior: namespaced
    type: 0
    resourceID: "${var.identity_resource_id}"
    clientID: "${var.identity_client_id}"
  
  azureIdentityBinding:
    name: "${var.identity_name}-binding"
    selector: "${var.identity_name}"
  EOF
  ]
}
