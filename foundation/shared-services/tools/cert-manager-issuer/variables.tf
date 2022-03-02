variable "namespace" {
  default = "default"
}

variable "issuer_type" {}

variable "issuer_name" {
  default = "toolchain-namespace-issuer"
}

variable "issuer_server" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "issuer_email" {
  default = "cloudservices@liatr.io"
}

variable "issuer_kind" {
  default = "Issuer"
}

variable "acme_solver" {
  default = "dns"
}

variable "provider_http_ingress_class" {
  default = "nginx"
}

variable "provider_dns_type" {
  default = "azureDNS"
}

variable "enabled" {
  default = true
}

variable "ca_secret" {
}

variable "azure_subscription_id" {
  type = string
}

variable "azure_resource_group_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "azure_managed_identity_client_id" {
  type = string
}
