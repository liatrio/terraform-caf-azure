resource "helm_release" "cert_issuer" {
  name      = "cert-issuer"
  namespace = var.namespace
  chart     = "${path.module}/charts/cert-manager-issuers"
  timeout   = 120
  wait      = true
  values = [templatefile("${path.module}/issuer-values.tpl", {
    issuer_name                      = var.issuer_name
    issuer_server                    = var.issuer_server
    issuer_email                     = var.issuer_email
    issuer_type                      = var.issuer_type
    issuer_kind                      = var.issuer_kind
    acme_solver                      = var.acme_solver
    provider_dns_type                = "azureDNS"
    ca_secret                        = var.ca_secret
    azure_subscription_id            = var.azure_subscription_id
    azure_resource_group_name        = var.azure_resource_group_name
    dns_zone_name                    = var.dns_zone_name
    azure_managed_identity_client_id = var.azure_managed_identity_client_id
  })]
}
