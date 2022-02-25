terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

#tfsec:ignore:azure-container-use-rbac-permissions
#tfsec:ignore:azure-container-logging
#tfsec:ignore:azure-container-limit-authorized-ips
#tfsec:ignore:azure-container-configured-network-policy
resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.lz_resource_group
  dns_prefix              = var.name
  private_dns_zone_id     = var.private_dns_zone_id
  private_cluster_enabled = true
  kubernetes_version      = var.kubernetes_version
  default_node_pool {
    name           = var.pool_name
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    user_assigned_identity_id = var.kubernetes_managed_identity
    type                      = "UserAssigned"
  }

  tags = var.tags

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }
}
