variable "namespace" {
  type        = string
  description = "Namespace in which to install the ingress and configure scope"
}

variable "name" {
  type        = string
  description = "Name suffix to apply to nginx ingress controller pod"
}

variable "load_balancer_ip" {
  type        = string
  description = "AKS service subnet IP address to assign to nginx ingress"
}
