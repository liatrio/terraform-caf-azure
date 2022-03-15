variable "dns_provider" {
  type = string
}

variable "service_account_annotations" {
  type    = map(string)
  default = {}
}

variable "namespace" {
  type = string
}

variable "release_name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "domain_filters" {
  type = list(string)
}

variable "pod_identity" {
  type        = string
  description = "Identity label to be used by AAD Pod Identities to bind to cert-manager pod"
}

variable "use_managed_identity_extension" {
  type    = string
  default = true
}

variable "exclude_domains" {
  type    = list(string)
  default = []
}
