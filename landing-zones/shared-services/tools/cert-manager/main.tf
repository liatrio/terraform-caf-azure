module "cert_manager" {
  source = "../../../../modules/tools/cert-manager"

  namespace = var.namespace
}

# data "aws_route53_zone" "zone" {
#   name = var.hosted_zone_name
# }

# module "issuer" {
#   source = "../../../../../common/cert-issuer"

#   namespace = var.namespace

#   issuer_name   = "staging-letsencrypt-dns"
#   issuer_kind   = "Issuer"
#   issuer_type   = "acme"
#   issuer_server = "https://acme-staging-v02.api.letsencrypt.org/directory"

#   acme_solver       = "dns"
#   provider_dns_type = "route53"

#   route53_dns_region      = "us-east-1"
#   route53_dns_hosted_zone = data.aws_route53_zone.zone.zone_id

#   depends_on = [
#     module.cert_manager,
#   ]
# }
