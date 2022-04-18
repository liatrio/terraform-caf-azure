variable "issuer_server" {
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  type        = string
  description = "Most likely prod (default) or staging LetsEncrypt ACME server"
}

variable "issuer_email" {
  type        = string
  description = "Email address to associate with cert issuer"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID to associate with issuer helm chart"
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

variable "dns_zone_name" {
  type        = string
  description = "External Public Azure DNS zone name to associate with issuer helm chart"
}

variable "dns_zone_resource_group_name" {
  type        = string
  description = "Azure resource group name to associate with issuer helm chart. Must match resource group of dns zone"
}

variable "external_app" {
  type        = bool
  description = "If true the following occurs: enables web hosting ports 80 and 443 externally, creates public DNS zone, creates external wildcard cert"
  default     = false
}
