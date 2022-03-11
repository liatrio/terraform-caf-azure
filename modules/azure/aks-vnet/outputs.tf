output "vnet_subnet_id" {
  value = tolist(azurerm_virtual_network.aks_vnet.subnet)[0].id
}

output "vnet_id" {
  value = azurerm_virtual_network.aks_vnet.id
}

output "aks_service_subnet_cidr" {
  value = local.aks_services_subnet
}

output "aks_dns_service_host" {
  value = local.aks_dns_service_host
}

output "service_endpoints_subnet_id" {
  value = azurerm_subnet.service_endpoints.id
}

output "service_endpoints_subnet_cidr" {
  value = azurerm_subnet.service_endpoints.address_prefixes.0
}
