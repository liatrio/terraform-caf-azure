resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = var.namespace
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  timeout    = 120
  version    = "v1.7.1"
  wait       = true

  set {
    name  = "global.leaderElection.namespace"
    value = var.namespace
  }
  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }
  set {
    name  = "securityContext.enabled"
    value = true
  }
  set {
    name  = "securityContext.fsGroup"
    value = 1001
  }
}
