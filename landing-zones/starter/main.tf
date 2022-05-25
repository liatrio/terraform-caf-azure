terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management
      ]
    }
  }
}

resource "azurerm_resource_group" "lz_resource_group" {
  name     = "rg-${var.prefix}-${var.name}-${var.environment}-${var.location}"
  location = var.location
}

module "vnet" {
  source = "../../modules/azure/vnet"

  name                            = var.name
  location                        = var.location
  vnet_address_range              = var.vnet_address_range
  resource_group_name             = azurerm_resource_group.lz_resource_group.name
  connectivity_dns_servers        = var.connectivity_dns_servers
  include_rules_allow_web_inbound = var.external_app
}

module "key_vault" {
  source = "../../modules/azure/key-vault"

  providers = {
    azurerm              = azurerm,
    azurerm.connectivity = azurerm.connectivity
  }

  location                         = var.location
  resource_group_name              = azurerm_resource_group.lz_resource_group.name
  env                              = var.environment
  workload                         = var.workload
  service_endpoints_subnet_id      = module.vnet.vnet_subnet[0].id
  connectivity_resource_group_name = var.connectivity_resource_group_name
  enabled_for_disk_encryption      = var.enabled_for_disk_encryption
  application_id                   = var.application_id
  certificate_permissions          = var.certificate_permissions
  key_permissions                  = var.key_permissions
  secret_permissions               = var.secret_permissions
  storage_permissions              = var.storage_permissions
}

resource "azurerm_virtual_hub_connection" "vnet_hub_connection" {
  count                     = var.enable_virtual_hub_connection == true ? 1 : 0
  provider                  = azurerm.connectivity
  name                      = "cn-${var.name}-connection-${var.environment}-${var.location}"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub[0].id
  remote_virtual_network_id = module.vnet.vnet_id
}

resource "azurerm_virtual_network_peering" "peer_virtual_network" {
  count                     = var.enable_vnet_peering == true ? 1 : 0
  provider                  = azurerm.connectivity
  name                      = "vnet-peer-${var.name}"
  resource_group_name       = "rg-${var.prefix}-connectivity-${var.environment}-${var.location}"
  virtual_network_name      = data.azurerm_virtual_network.target_virtual_network[0].name
  remote_virtual_network_id = module.vnet.vnet_id
}
