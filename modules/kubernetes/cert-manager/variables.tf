variable "namespace" {
  type        = string
  description = "Supply a namespace to associate with cert-manager deployment. e.g. toolchain"
}

variable "pod_identity" {
  type = string
  description = "Identity label to be used by AAD Pod Identities to bind to cert-manager pod"
}
