output "connectivity_resource_groups" {
  value = azurerm_resource_group.caf_connectivity.name
}

output "connectivity_vwan_id" {
  value = azurerm_virtual_wan.caf_vwan.id
}

output "connectivity_virtual_hub_id" {
  value = azurerm_virtual_hub.caf_hub.id
}

output "connectivity_vpn_id" {
  value = azurerm_point_to_site_vpn_gateway.hub_vpn_gateway.id
}

output "connectivity_private_dns_zone_ids" {
  value = {
    for k, zone in local.azure_paas_private_dns_zones : k => module.private_dns[k].dns_zone_id
  }
}
