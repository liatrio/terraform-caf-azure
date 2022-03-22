variable "issuer_server" {
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  type        = string
  description = "Most likely prod (default) or staging LetsEncrypt ACME server"
}

variable "issuer_email" {
  default     = "cloudservices@liatr.io"
  type        = string
  description = "Email address to associate with cert issuer"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID to associate with issuer helm chart"
}

variable "dns_zone_resource_group_name" {
  type        = string
  description = "Azure resource group name to associate with issuer helm chart. Must match resource group of dns zone"
}

variable "dns_zone_name" {
  type        = string
  description = "External Public Azure DNS zone name to associate with issuer helm chart"
}

variable "azure_managed_identity_client_id" {
  type        = string
  description = "Azure managed identity client ID to associate with issuer helm chart. Must have 'DNS Zone Contributor' role assignment"
}

variable "github_org" {
  type = string
}

variable "github_runners" {
  type    = map(any)
  default = {}
}

variable "aad_pod_identity_client_id" {
  type        = string
  description = "AAD Pod Identities managed identity client ID"
}

variable "aad_pod_identity_resource_id" {
  type        = string
  description = "AAD Pod Identities managed identity resource ID"
}

variable "external_dns_aad_pod_identity_client_id" {
  type        = string
  description = "AAD Pod Identities managed identity client ID for External-DNS"
}

variable "external_dns_aad_pod_identity_resource_id" {
  type        = string
  description = "AAD Pod Identities managed identity resource ID for External-DNS"
}

variable "monitoring_namespace" {
  type    = string
  default = "monitoring"
}

variable "key_vault_id" {
  type = string
}
