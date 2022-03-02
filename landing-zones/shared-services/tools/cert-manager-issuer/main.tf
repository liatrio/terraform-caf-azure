module "cert_manager_issuer" {
  source = "../../../../modules/tools/cert-manager-issuer"

  namespace                        = var.namespace
  issuer_type                      = var.issuer_type
  issuer_name                      = var.issuer_name
  issuer_server                    = var.issuer_server
  issuer_email                     = var.issuer_email
  issuer_kind                      = var.issuer_kind
  acme_solver                      = var.acme_solver
  provider_http_ingress_class      = var.provider_http_ingress_class
  provider_dns_type                = var.provider_dns_type
  enabled                          = var.enabled
  ca_secret                        = var.ca_secret
  azure_subscription_id            = var.azure_subscription_id
  azure_resource_group_name        = var.azure_resource_group_name
  dns_zone_name                    = var.dns_zone_name
  azure_managed_identity_client_id = var.azure_managed_identity_client_id
}
