resource "helm_release" "external_dns" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.1.8"
  namespace  = var.namespace
  name       = var.release_name
  timeout    = 600

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      resource_group                  = var.resource_group
      tenant_id                       = var.tenant_id
      subscription_id                 = var.subscription_id
      use_managed_identity_extension  = var.use_managed_identity_extension
      domain_provider                 = var.dns_provider
      domain_filters                  = yamlencode(var.domain_filters)
      istio_enabled                   = var.istio_enabled
      watch_services                  = var.watch_services
      exclude_domains                 = var.exclude_domains
    })
  ]

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns_service_account[0].metadata[0].name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "policy"
    value = "sync"
  }
  set {
    name  = "logLevel"
    value = "debug"
  }
}

resource "kubernetes_service_account" "external_dns_service_account" {
  metadata {
    name        = var.release_name
    namespace   = var.namespace
    annotations = var.service_account_annotations
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "external_dns_role" {
  metadata {
    name = "${var.release_name}-manager"
  }
  rule {
    api_groups = [
      ""
    ]
    resources = [
      "services",
      "pods",
      "nodes"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }

  rule {
    api_groups = [
      "extensions",
      "networking.k8s.io"
    ]
    resources = [
      "ingresses"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }

  rule {
    api_groups = [
      "networking.istio.io"
    ]
    resources = [
      "gateways"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns_role_binding" {
  metadata {
    name = "${var.release_name}-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns_role[0].metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns_service_account[0].metadata[0].name
    namespace = var.namespace
  }
}
