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
    name                = var.pool_name
    vm_size             = var.vm_size
    vnet_subnet_id      = var.vnet_subnet_id
    enable_auto_scaling = true
    node_count          = var.node_count_min
    min_count           = var.node_count_min
    max_count           = var.node_count_max
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

  auto_scaler_profile {
    balance_similar_node_groups      = lookup(var.autoscaler_config, "balance_similar_node_groups", false)
    expander                         = lookup(var.autoscaler_config, "expander", "random")
    max_graceful_termination_sec     = lookup(var.autoscaler_config, "max_graceful_termination_sec", 600)
    max_node_provisioning_time       = lookup(var.autoscaler_config, "max_node_provisioning_time", "15m")
    max_unready_nodes                = lookup(var.autoscaler_config, "max_unready_nodes", 3)
    max_unready_percentage           = lookup(var.autoscaler_config, "max_unready_percentage", 45)
    new_pod_scale_up_delay           = lookup(var.autoscaler_config, "new_pod_scale_up_delay", "10s")
    scale_down_delay_after_add       = lookup(var.autoscaler_config, "scale_down_delay_after_add", "10m")
    scale_down_delay_after_delete    = lookup(var.autoscaler_config, "scale_down_delay_after_delete", "10s")
    scale_down_delay_after_failure   = lookup(var.autoscaler_config, "scale_down_delay_after_failure", "3m")
    scan_interval                    = lookup(var.autoscaler_config, "scan_interval", "10s")
    scale_down_unneeded              = lookup(var.autoscaler_config, "scale_down_unneeded", "10m")
    scale_down_unready               = lookup(var.autoscaler_config, "scale_down_unready", "20m")
    scale_down_utilization_threshold = lookup(var.autoscaler_config, "scale_down_utilization_threshold", 0.5)
    empty_bulk_delete_max            = lookup(var.autoscaler_config, "empty_bulk_delete_max", 10)
    skip_nodes_with_local_storage    = lookup(var.autoscaler_config, "skip_nodes_with_local_storage", true)
    skip_nodes_with_system_pods      = lookup(var.autoscaler_config, "skip_nodes_with_system_pods", true)
  }
}
