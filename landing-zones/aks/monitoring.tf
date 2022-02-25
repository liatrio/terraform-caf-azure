module "kube-prometheus-stack" {
  source = "../../modules/kube-prometheus-stack"

  enable_grafana      = false
  enable_alertmanager = false
}