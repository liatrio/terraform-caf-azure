resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

module "kube_prometheus_stack" {
  source = "../../../modules/kube-prometheus-stack"

  namespace                        = kubernetes_namespace.monitoring.metadata[0].name
  enable_grafana                   = false
  enable_alertmanager              = true
  grafana_hostname                 = "placeholder-domain"
  alertmanager_hostname            = "placeholder-domain"
  prometheus_slack_webhook_url     = ""
  prometheus_slack_channel         = ""
  grafana_ingress_annotations      = {}
  alertmanager_ingress_annotations = {}
}
