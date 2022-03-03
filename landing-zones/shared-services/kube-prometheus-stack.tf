module "monitoring_namespace" {
  source    = "../../modules/kube-namespace"
  namespace = var.monitoring_namespace
  annotations = {
    name    = var.monitoring_namespace
    cluster = var.aks_name
  }
}

module "kube_prometheus_stack" {
  source = "../../modules/kube-prometheus-stack"

  namespace                        = module.monitoring_namespace.name
}