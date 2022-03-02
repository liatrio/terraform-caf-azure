variable "namespace" {
  default = "default"
}

variable "issuer_name" {
  default = "toolchain-namespace-issuer"
}

variable "issuer_kind" {
  default = "ClusterIssuer"
}

variable "issuer_server" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "issuer_email" {
  default = "cloudservices@liatr.io"
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
