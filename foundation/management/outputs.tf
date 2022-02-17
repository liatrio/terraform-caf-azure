output "foundation" {
  value = azurerm_management_group.foundation.id
}

output "platform" {
  value = azurerm_management_group.platform.id
}

output "connectivity" {
  value = azurerm_management_group.connectivity.id
}

output "identity" {
  value = azurerm_management_group.identity.id
}

output "management" {
  value = azurerm_management_group.management.id
}

output "landing_zones" {
  value = azurerm_management_group.landing_zones.id
}

output "dynamic_management_groups" {
  // value = azurerm_management_group.dynamic_management_group[*].id
  value = [for k,v in azurerm_management_group.dynamic : v.id]
}

output "sandboxes" {
  value = azurerm_management_group.sandboxes.id
}

output "decommissioned" {
  value = azurerm_management_group.decommissioned.id
}
