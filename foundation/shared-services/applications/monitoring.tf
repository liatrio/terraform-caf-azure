resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

module "kube_prometheus_stack" {
  source = "../../../modules/kube-prometheus-stack"

  namespace           = kubernetes_namespace.monitoring.name
  enable_grafana      = true
  enable_alertmanager = true
}
