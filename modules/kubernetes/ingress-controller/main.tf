resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-${var.name}"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = "v1.1.2"
  values = [<<-EOF
  controller:
    replicaCount: 2
    service:
      type: LoadBalancer
      loadBalancerIP: ${var.load_balancer_ip}
      annotations:
        service.beta.kubernetes.io/azure-load-balancer-internal: "true"      
  EOF
  ]
}
