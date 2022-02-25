variable "prometheus_slack_webhook_url" {
  default = ""
}

variable "prometheus_slack_channel" {
  default = ""
}

variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_hostname" {
  default = ""
}

variable "alertmanager_hostname" {
  default = ""
}

variable "alertmanager_ingress_annotations" {
  type    = map(string)
  default = {}
}

variable "grafana_ingress_annotations" {
  type    = map(string)
  default = {}
}

variable "enable_grafana" {}

variable "enable_alertmanager" {}
