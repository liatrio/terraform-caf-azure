variable "github_runner_namespace" {
  default     = "github-runners"
  description = "Namespace for github runner controller and github runners"
}

variable "issuer_name" {
  default     = "cluster-issuer"
  type        = string
  description = "Descriptive name for the issuer. Consider scope when selecting"
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

variable "github_org" {
  type = string
}

variable "github_runners" {
  type    = map(any)
  default = {}
}

