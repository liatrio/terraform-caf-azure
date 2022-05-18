output "vnet_name" {
  value = azurerm.azurerm_virtual_network.name
}

output "vnet_subnet_id" {
  value = azurerm_subnet.aks_nodes_and_pods.id
}

output "vnet_service_endpoints_subnet_name" {
  value = azurerm_subnet.service_endpoints.name
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
