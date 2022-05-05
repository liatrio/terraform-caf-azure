module "aks_vnet" {
  source                   = "../../../modules/azure/aks-vnet"
  name                     = local.shared_services_name
  location                 = var.location
  vnet_address_range       = var.vnet_address_range
  resource_group_name      = azurerm_resource_group.resource_group.name
  connectivity_dns_servers = var.connectivity_dns_servers
}

data "azurerm_private_dns_zone" "aks_private_dns_id" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.connectivity_resource_group_name
  provider            = azurerm.connectivity
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-management-${var.environment}-${var.location}"
  resource_group_name = "rg-${var.prefix}-management-${var.environment}-${var.location}"
}

module "aks" {
  source                      = "../../../modules/azure/aks"
  location                    = var.location
  name                        = local.shared_services_name
  pool_name                   = var.pool_name
  node_count_min              = var.node_count_min
  node_count_max              = var.node_count_max
  vm_size                     = var.vm_size
  vnet_subnet_id              = module.aks_vnet.vnet_subnet_id
  aks_service_subnet_cidr     = module.aks_vnet.aks_service_subnet_cidr
  aks_dns_service_ip          = module.aks_vnet.aks_dns_service_host
  kubernetes_version          = var.kubernetes_version
  kubernetes_managed_identity = azurerm_user_assigned_identity.shared_services_msi.id
  lz_resource_group           = azurerm_resource_group.resource_group.name
  private_dns_zone_id         = data.azurerm_private_dns_zone.aks_private_dns_id.id
  log_analytics_workspace     = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  enable_aks_policy_addon     = var.enable_aks_policy_addon
  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.cluster_contributor,
    azurerm_role_assignment.subscription_connectivity_dns_contributor
  ]
}

data "azurerm_virtual_hub" "connectivity_hub" {
  provider            = azurerm.connectivity
  name                = "vhub-${var.prefix}-${var.environment}-${var.location}"
  resource_group_name = "rg-${var.prefix}-connectivity-${var.environment}-${var.location}"
}

resource "azurerm_virtual_hub_connection" "aks_vnet_hub_connection" {
  provider                  = azurerm.connectivity
  name                      = "vhub-${var.prefix}-${local.shared_services_name}-connection-${var.environment}-${var.location}"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub.id
  remote_virtual_network_id = module.aks_vnet.vnet_id
}
