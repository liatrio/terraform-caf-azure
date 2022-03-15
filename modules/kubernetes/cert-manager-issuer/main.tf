resource "helm_release" "cert_issuer" {
  name      = var.issuer_name
  namespace = var.namespace
  chart     = "${path.module}/charts/cert-manager-issuers"
  timeout   = 120
  wait      = true
  values = [templatefile("${path.module}/issuer-values.yaml.tpl", {
    issuer_name     = var.issuer_name
    issuer_server   = var.issuer_server
    issuer_email    = var.issuer_email
    subscription_id = var.azure_subscription_id
    resource_group  = var.resource_group_name
    dns_zone_name   = var.dns_zone_name
  })]
}
