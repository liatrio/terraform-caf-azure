output "cert_name" {
  value = var.name
}

output "cert_secret_name" {
  value = "${var.name}-certificate"

  depends_on = [
    helm_release.certificates
  ]
}
