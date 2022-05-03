locals {
  internal_dns_zone_name = "internal.${var.public_dns_zone_name}"
}

module "shared_services_public_dns_zone" {
  providers = {
    azurerm                 = azurerm
    azurerm.parent_dns_zone = azurerm.connectivity
    azurerm.connectivity    = azurerm.connectivity
  }
  source                              = "../../../modules/azure/public-dns-zone"
  resource_group_name                 = azurerm_resource_group.resource_group.name
  dns_zone_name                       = var.public_dns_zone_name
  parent_dns_zone_name                = var.parent_dns_zone_name
  parent_dns_zone_resource_group_name = var.connectivity_resource_group_name
}

data "azurerm_virtual_network" "connectivity_vnet" {
  provider            = azurerm.connectivity
  name                = "vnet-connectivity-apps"
  resource_group_name = var.connectivity_resource_group_name
}

module "shared_services_internal_public_dns_zone" {
  providers = {
    azurerm                 = azurerm
    azurerm.parent_dns_zone = azurerm
    azurerm.connectivity    = azurerm.connectivity

  }
  source = "../../../modules/azure/public-dns-zone"

  dns_zone_name                       = local.internal_dns_zone_name
  resource_group_name                 = azurerm_resource_group.resource_group.name
  parent_dns_zone_name                = var.public_dns_zone_name
  parent_dns_zone_resource_group_name = azurerm_resource_group.resource_group.name
}

module "shared_services_internal_private_dns_zone" {
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  source = "../../../modules/azure/private-dns-zone"

  dns_zone_name             = local.internal_dns_zone_name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resource_group.name
  linked_virtual_network_id = data.azurerm_virtual_network.connectivity_vnet.id
}
