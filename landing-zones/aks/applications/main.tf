terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4.1"
    }
  }
}

data "azurerm_client_config" "current" {}
resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    name = "toolchain"
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"
}

locals {
  internal_dns_zone_name = "internal.${var.dns_zone_name}"
}
