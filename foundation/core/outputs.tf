output "connectivity_private_dns_zone_ids" {
  value = {
    for k, zone in local.azure_paas_private_dns_zones : k => module.azure_paas_private_dns[k].dns_zone_id
  }
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


output "log_analytics_workspace" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
