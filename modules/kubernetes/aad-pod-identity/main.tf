resource "helm_release" "aad_pod_identity_controller" {
  name       = "aad-pod-identity"
  namespace  = "kube-system"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "4.1.8"
  wait       = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {})
  ]
}
