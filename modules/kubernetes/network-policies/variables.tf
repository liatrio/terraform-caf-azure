variable "excluded_namespaces" {
  description = "Namespaces to exclude from default network policy"
  type        = list(any)
  default = [
    "kube-system",
    "gatekeeper-system",
    "calico-system",
    "tigera-operator",
    "toolchain"
  ]
}

variable "default_deny" {
  description = "Apply a default deny rule across the cluster (except for on excluded namespaces). DNS is exempt."
  type        = bool
  default     = true
}
