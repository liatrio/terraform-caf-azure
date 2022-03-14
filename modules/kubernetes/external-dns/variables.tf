variable "enabled" {
  type    = bool
  default = true
}

variable "istio_enabled" {
  type = bool
}

variable "watch_services" {
  type        = bool
  default     = false
  description = "when true, externaldns will create DNS entries for kubernetes service resources"
}

variable "dns_provider" {
  type    = string
  default = "azure"
}

variable "service_account_annotations" {
  type    = map(string)
  default = {}
}

variable "namespace" {
  type = string
}

variable "release_name" {
  default = "external-dns"
}

variable "exclude_domains" {
  type    = list(string)
  default = []
}

variable "resource_group" {
  type = string
  default = "caf-shared-services-staging-rg"
}

variable "tenant_id" {
  type = string
  default = "aac9fb06-16d1-43ae-9c85-6df179535e1e"
}

variable "subscription_id" {
  type = string
  default = "8ae1ed8a-364b-4879-9d6d-58a983f26faf"
}

variable "use_managed_identity_extension" {
  type = string
  default = true
}

variable "domain_filters" {
  type = list(string)
  default = ["internal.shared-svc-staging.azurecaf.liatr.io"]
}