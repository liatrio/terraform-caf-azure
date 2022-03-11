output "issuer_name" {
  value = var.issuer_name

  depends_on = [
    helm_release.cert_issuer
  ]
}

output "issuer_kind" {
  value = var.issuer_kind
}
