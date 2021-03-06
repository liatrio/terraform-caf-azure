locals {
  # map of azurerm services to fqdns for private dns zones
  # keys are named after the terraform resources that these private dns zones would be used for
  azure_paas_private_dns_zones = {
    kubernetes_cluster = "privatelink.${var.location}.azmk8s.io"
    container_registry = "privatelink.azurecr.io"
    key_vault          = "privatelink.vaultcore.azure.net"
    mysql              = "mysql.database.azure.com"
  }
}

module "dns_resolver" {
  providers = {
    azurerm = azurerm.connectivity
  }

  source = "../../modules/azure/vpn-dns-resolver"

  location             = var.location
  resource_group_name  = azurerm_resource_group.caf_connectivity.name
  virtual_network_name = azurerm_virtual_network.connectivity_vnet.name
  subnet_cidr          = local.coredns_subnet_cidr
}

module "azure_paas_private_dns" {
  providers = {
    azurerm              = azurerm.connectivity
    azurerm.connectivity = azurerm.connectivity
  }

  source = "../../modules/azure/private-dns-zone"

  for_each                  = local.azure_paas_private_dns_zones
  location                  = var.enable_point_to_site_vpn == true ? azurerm_point_to_site_vpn_gateway.hub_vpn_gateway[0].location : azurerm_resource_group.caf_connectivity.location
  resource_group_name       = azurerm_resource_group.caf_connectivity.name
  linked_virtual_network_id = azurerm_virtual_network.connectivity_vnet.id
  dns_zone_name             = each.value
  tags                      = { "resource" = each.key }
}

module "public_dns" {
  providers = {
    azurerm                 = azurerm.connectivity
    azurerm.parent_dns_zone = azurerm.connectivity
    azurerm.connectivity    = azurerm.connectivity
  }

  source              = "../../modules/azure/public-dns-zone"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  dns_zone_name       = var.root_dns_zone
  tags                = var.root_dns_tags
}
