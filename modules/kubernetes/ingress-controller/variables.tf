variable "namespace" {
  type        = string
  description = "Namespace in which to install the ingress and configure scope"
}

variable "name" {
  type        = string
  description = "Name suffix to apply to nginx ingress controller pod"
}

variable "internal" {
  type        = string
  description = "If true, sets Azure load balancer internal annotation"
}

variable "default_certificate" {
  default = ""
}

variable "extra_args" {
  default = {}
}
