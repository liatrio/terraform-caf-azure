output "connectivity_private_dns_zone_ids" {
  value = module.connectivity.connectivity_private_dns_zone_ids
}

output "foundation" {
  value = azurerm_management_group.foundation.id
}

output "platform" {
  value = azurerm_management_group.platform.id
}

output "landing_zones" {
  value = azurerm_management_group.landing_zones.id
}

output "dynamic_management_groups" {
  value = [for k, v in azurerm_management_group.dynamic : v.id]
}

output "sandboxes" {
  value = azurerm_management_group.sandboxes.id
}

output "decommissioned" {
  value = azurerm_management_group.decommissioned.id
}

output "shared_svc" {
  value = azurerm_management_group.shared_svc.id
}
