module "cert_manager_issuer" {
  source = "../../../../modules/tools/cert-manager-issuer"

  namespace                        = "toolchain"
  issuer_type                      = "acme"
  issuer_name                      = "toolchain-namespace-issuer"
  issuer_server                    = "https://acme-v02.api.letsencrypt.org/directory"
  issuer_email                     = "cloudservices@liatr.io"
  issuer_kind                      = "ClusterIssuer"
  acme_solver                      = "dns"
  provider_http_ingress_class      = "nginx"
  provider_dns_type                = "azureDNS"
  enabled                          = true
  ca_secret                        = "ca-certificate"
  azure_subscription_id            = string
  azure_resource_group_name        = string
  dns_zone_name                    = string
  azure_managed_identity_client_id = string
}
