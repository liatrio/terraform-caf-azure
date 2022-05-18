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
  name     = "rg-${var.prefix}-${var.name}-${var.env}-${var.location}"
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

module "key_vault" {
  source = "../../../modules/azure/key-vault"

  providers = {
    azurerm              = azurerm,
    azurerm.connectivity = azurerm.connectivity
  }

  location                         = var.location
  resource_group_name              = azurerm_resource_group.lz_resource_group.name
  env                              = var.env
  workload                         = var.workload
  service_endpoints_subnet_id      = module.aks_vnet.service_endpoints_subnet_id
  connectivity_resource_group_name = var.connectivity_resource_group_name
  enabled_for_disk_encryption      = var.enabled_for_disk_encryption
  application_id                   = var.application_id
  certificate_permissions          = var.certificate_permissions
  key_permissions                  = var.key_permissions
  secret_permissions               = var.secret_permissions
  storage_permissions              = var.storage_permissions
}

module "key_gen" {
  source = "../../../modules/azure/key-gen"

  providers = {
    azurerm              = azurerm,
    azurerm.connectivity = azurerm.connectivity
  }

  location                    = var.location
  resource_group_name         = azurerm_resource_group.lz_resource_group.name
  vault_key_to_create         = var.vault_key_to_create
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  key_vault_id                = module.key_vault.key_vault_id
}

module "aks" {
  source = "../../../modules/azure/aks"

  env                         = var.env
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
  kubernetes_managed_identity = [azurerm_user_assigned_identity.aks_msi.id]
  lz_resource_group           = azurerm_resource_group.lz_resource_group.name
  private_dns_zone_id         = data.azurerm_private_dns_zone.aks_private_dns_id.id
  log_analytics_workspace     = local.log_analytics_workspace_id
  enable_aks_policy_addon     = var.enable_aks_policy_addon
  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.subscription_connectivity_dns_contributor
  ]
  aks_enable_disk_encryption = var.aks_enable_disk_encryption
  disk_encryption_set_id     = module.key_gen.disk_encryption_set_id != null ? module.key_gen.disk_encryption_set_id : null
}

resource "azurerm_virtual_hub_connection" "aks_vnet_hub_connection" {
  count                     = var.enable_virtual_hub_connection == true ? 1 : 0
  provider                  = azurerm.connectivity
  name                      = "cn-${var.name}-connection-${var.env}-${var.location}"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub[0].id
  remote_virtual_network_id = module.aks_vnet.vnet_id
}

resource "azurerm_virtual_network_peering" "peer_virtual_network" {
  count                     = var.enable_vnet_peering == true ? 1 : 0
  provider                  = azurerm.connectivity
  name                      = "vnet-peer-${var.name}"
  resource_group_name       = "rg-${var.prefix}-connectivity-${var.env}-${var.location}"
  virtual_network_name      = data.azurerm_virtual_network.target_virtual_network[0].name
  remote_virtual_network_id = module.aks_vnet.vnet_id
}

module "app_service" {
  source = "../../../modules/azure/app-service"

  env            = var.env
  short_location = var.short_location
  location       = var.location
  workload       = var.workload
  vnet_rg_name   = azurerm_resource_group.lz_resource_group.name
  vnet_name      = module.aks_vnet.vnet_name
  subnet_name    = module.aks_vnet.vnet_service_endpoints_subnet_name
  dns_rg_name    = azurerm_resource_group.lz_resource_group.name
}
