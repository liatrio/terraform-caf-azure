resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

module "kube_prometheus_stack" {
  source = "../../../modules/kube-prometheus-stack"

  namespace                    = kubernetes_namespace.monitoring.metadata[0].name
  enable_grafana               = true
  enable_alertmanager          = true
  grafana_hostname             = "grafana.${local.internal_dns_zone_name}"
  alertmanager_hostname        = "alert-manager.${local.internal_dns_zone_name}"
  prometheus_slack_webhook_url = ""
  prometheus_slack_channel     = ""
  grafana_ingress_annotations = {
    "nginx.ingress.kubernetes.io/force-ssl-redirect" : "true"
    "kubernetes.io/ingress.class" : module.internal_ingress_controller.ingress_class
  }
  alertmanager_ingress_annotations = {
    "nginx.ingress.kubernetes.io/force-ssl-redirect" : "true"
    "kubernetes.io/ingress.class" : module.internal_ingress_controller.ingress_class
  }
}
