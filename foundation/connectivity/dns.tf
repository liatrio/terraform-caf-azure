module "private_dns" {
  source = "../../modules/private-dns-zones"

  location                     = azurerm_point_to_site_vpn_gateway.hub_vpn_gateway.location
  resource_group_name          = azurerm_resource_group.caf_connectivity.name
  linked_virtual_network_id    = azurerm_virtual_network.connectivity_vnet.id
  azure_paas_private_dns_zones = var.private_dns_zones
}

module "public_dns" {
  source              = "../../modules/public-dns-zones"
  location            = azurerm_point_to_site_vpn_gateway.hub_vpn_gateway.location
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  root_dns_zone       = var.public_dns_root_zone
  tags                = var.root_dns_tag
}
