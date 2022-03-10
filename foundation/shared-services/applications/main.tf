terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
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

resource "kubernetes_namespace" "toolchain_namespace" {
  metadata {
    name = "toolchain"
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"
}


