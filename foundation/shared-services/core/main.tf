terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
      configuration_aliases = [
        azurerm.connectivity
    ] }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-${var.name}-rg"
  location = var.location
}

module "aks_vnet" {
  source             = "../../../modules/azure/aks-vnet"
  name               = var.name
  location           = var.location
  vnet_address_range = var.vnet_address_range
  lz_resource_group  = azurerm_resource_group.resource_group.name
}

data "azurerm_private_dns_zone" "aks_private_dns_id" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = "caf-connectivity"
  provider            = azurerm.connectivity
}

module "aks" {
  source                      = "../../../modules/azure/aks"
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
  kubernetes_managed_identity = azurerm_user_assigned_identity.shared_services_msi.id
  lz_resource_group           = azurerm_resource_group.resource_group.name
  private_dns_zone_id         = data.azurerm_private_dns_zone.aks_private_dns_id.id
  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.cluster_contributor,
    azurerm_role_assignment.subscription_connectivity_dns_contributor
  ]
}

data "azurerm_virtual_hub" "connectivity_hub" {
  provider            = azurerm.connectivity
  name                = "${var.prefix}-hub-${var.location}"
  resource_group_name = "${var.prefix}-connectivity"
}

resource "azurerm_virtual_hub_connection" "aks_vnet_hub_connection" {
  provider                  = azurerm.connectivity
  name                      = "${var.prefix}-${var.name}-connection"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub.id
  remote_virtual_network_id = module.aks_vnet.vnet_id
}
