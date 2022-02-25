module "kube-prometheus-stack" {
  source = "../../modules/kube-prometheus-stack"

  enable_grafana      = var.name
  enable_alertmanager = var.location
}