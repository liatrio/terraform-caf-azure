variable "namespace" {
  type        = string
  description = "Supply a namespace to associate with cert-manager deployment. e.g. toolchain"
}

variable "pod_labels" {
  type        = list(string)
  description = "List of labels to apply to cert-manager pod. Must include AAD pod identity label"
}
