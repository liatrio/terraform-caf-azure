resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = var.namespace
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  timeout    = 120
  version    = "v1.7.1"
  wait       = true

  values = [<<-EOF
  global:
    leaderElection:
      namespace: ${var.namespace}
  installCRDs: true
  serviceAccount:
    name: cert-manager
  securityContext:
    enabled: true
    fsGroup: 1001
  podLabels:
    aadpodidbinding: ${var.pod_identity}
  EOF
  ]
}
