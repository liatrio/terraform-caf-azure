resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.toolchain.metadata.0.name
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  timeout    = 120
  version    = "v1.4.0"
  wait       = true

  set {
    name  = "global.leaderElection.namespace"
    value = kubernetes_namespace.toolchain.metadata.0.name
  }
  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }
  set {
    name  = "securityContext.enabled"
    value = true
  }
  set {
    name  = "securityContext.fsGroup"
    value = 1001
  }
}

resource "kubernetes_namespace" "toolchain" {
  metadata {
    annotations = {
      name = "toolchain"
    }
    name = "toolchain"
  }
}


# resource "time_sleep" "wait_for_cert_manager" {
#   depends_on = [helm_release.cert_manager]

#   create_duration = "20s"
# }

# resource "helm_release" "cert_issuer" {
#   name      = "cert-issuer"
#   namespace = kubernetes_namespace.toolchain.metadata.0.name
#   chart     = "${path.module}/charts/cert-manager-issuers"
#   timeout   = 120
#   wait      = true

#   set {
#     name  = "sp.clientID"
#     value = azuread_service_principal.aks.application_id
#   }

#   set {
#     name  = "sp.subscriptionID"
#     value = local.dns_zone_subscr
#   }

#   set {
#     name  = "sp.tenantID"
#     value = data.azurerm_subscription.current.tenant_id
#   }

#   set {
#     name  = "sp.resourceGroup"
#     value = local.dns_zone_rg
#   }

#   set {
#     name  = "zoneName"
#     value = azurerm_dns_zone.aks.name
#   }

#   depends_on = [time_sleep.wait_for_cert_manager]
# }
