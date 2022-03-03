variable "namespace" {
  type        = string
  description = "Supply a namespace that matches cert-manager"
}

variable "issuer_name" {
  default     = "cluster-issuer"
  type        = string
  description = "Descriptive name for the issuer. Consider scope when selecting"
}

variable "issuer_kind" {
  default     = "ClusterIssuer"
  type        = string
  description = "Must be a valid cert-manager issuer kind to apply in the helm chart"
}

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

variable "azure_resource_group_name" {
  type        = string
  description = "Azure resource group name to associate with issuer helm chart"
}

variable "dns_zone_name" {
  type        = string
  description = "Azure DNS zone name to associate with issuer helm chart"
}

variable "azure_managed_identity_client_id" {
  type        = string
  description = "Azure managed identity client ID to associate with issuer helm chart. Must have 'DNS Zone Contributor' role assignment"
}
