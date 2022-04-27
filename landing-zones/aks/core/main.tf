terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management
      ]
    }
  }
}

resource "azurerm_resource_group" "lz_resource_group" {
  name     = "${var.prefix}-${var.name}-rg"
  location = var.location
}

module "aks_vnet" {
  source = "../../../modules/azure/aks-vnet"

  name                            = var.name
  location                        = var.location
  vnet_address_range              = var.vnet_address_range
  resource_group_name             = azurerm_resource_group.lz_resource_group.name
  connectivity_dns_servers        = var.connectivity_dns_servers
  include_rules_allow_web_inbound = var.external_app
}

data "azurerm_private_dns_zone" "aks_private_dns_id" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.connectivity_resource_group_name
  provider            = azurerm.connectivity
}

data "azurerm_log_analytics_workspace" "management" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-management"
  resource_group_name = "rg-${var.prefix}-management"
}

resource "azurerm_security_center_workspace" "defender" {
  count        = var.enable_ms_defender == true ? 1 : 0
  scope        = data.azurerm_subscription.current.id
  workspace_id = data.azurerm_log_analytics_workspace.management.id
}

module "aks" {
  source = "../../../modules/azure/aks"

  location                    = var.location
  name                        = var.name
  pool_name                   = var.pool_name
  node_count_min              = var.node_count_min
  node_count_max              = var.node_count_max
  vm_size                     = var.vm_size
  vnet_subnet_id              = module.aks_vnet.vnet_subnet_id
  aks_service_subnet_cidr     = module.aks_vnet.aks_service_subnet_cidr
  aks_dns_service_ip          = module.aks_vnet.aks_dns_service_host
  kubernetes_version          = var.kubernetes_version
  kubernetes_managed_identity = azurerm_user_assigned_identity.aks_msi.id
  lz_resource_group           = azurerm_resource_group.lz_resource_group.name
  private_dns_zone_id         = data.azurerm_private_dns_zone.aks_private_dns_id.id
  log_analytics_workspace     = data.azurerm_log_analytics_workspace.management.id
  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.subscription_connectivity_dns_contributor
  ]
}

data "azurerm_virtual_hub" "connectivity_hub" {
  count               = var.enable_virtual_hub_connection == true ? 1 : 0
  provider            = azurerm.connectivity
  name                = "${var.prefix}-hub-${var.location}"
  resource_group_name = "${var.prefix}-connectivity"
}

resource "azurerm_virtual_hub_connection" "aks_vnet_hub_connection" {
  count                     = var.enable_virtual_hub_connection == true ? 1 : 0
  provider                  = azurerm.connectivity
  name                      = "${var.name}-connection"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub[0].id
  remote_virtual_network_id = module.aks_vnet.vnet_id
}

data "azurerm_virtual_network" "target_virtual_network" {
  count               = var.enable_vnet_peering == true ? 1 : 0
  provider            = azurerm.connectivity
  name                = "${var.prefix}-vnet-hub-${var.location}"
  resource_group_name = "${var.prefix}-connectivity"
}

resource "azurerm_virtual_network_peering" "peer_virtual_network" {
  count                     = var.enable_vnet_peering == true ? 1 : 0
  provider                  = azurerm.connectivity
  name                      = "peer-${var.name}"
  resource_group_name       = "${var.prefix}-connectivity"
  virtual_network_name      = data.azurerm_virtual_network.target_virtual_network[0].name
  remote_virtual_network_id = module.aks_vnet.vnet_id
}
