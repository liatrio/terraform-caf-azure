module "ingress_controller" {
  source           = "../../../modules/kubernetes/ingress-controller"
  load_balancer_ip = var.ingress_host_ip
}
