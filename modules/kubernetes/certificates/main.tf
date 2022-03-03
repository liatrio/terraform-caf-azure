resource "helm_release" "certificates" {
  name      = var.name
  namespace = var.namespace
  chart     = "${path.module}/charts/certificates"
  timeout   = 600
  wait      = true

  values = [templatefile("${path.module}/certificate-values.tpl", {
    domain        = var.domain
    altname       = var.altname
    wait_for_cert = var.wait_for_cert
    issuer_name   = var.issuer_name
  })]
}
