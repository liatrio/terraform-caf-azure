variable "namespace" {
  type        = string
  description = "Namespace in which to install the ingress and configure scope"
}

variable "name" {
  type        = string
  description = "Name suffix to apply to nginx ingress controller pod"
}
