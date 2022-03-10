variable "namespace" {
  description = "Namespace to deploy the controller to"
}

variable "github_org" {
  type = string
}

variable "github_webhook_annotations" {
  type        = map(string)
  description = "Annotations for githubWebhookServer Ingress"
  default     = {}
}

variable "ingress_domain" {
  type = string
}

variable "controller_replica_count" {
  type        = number
  default     = 1
  description = "How many actions runner controller instances to deploy"
}

variable "auth_pat_secret_name" {
  type        = string
  description = "Github pat for github runners"
}
