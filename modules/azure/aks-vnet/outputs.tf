output "vnet_subnet_id" {
  value = tolist(azurerm_virtual_network.aks_vnet.subnet)[0].id
}

output "vnet_id" {
  value = azurerm_virtual_network.aks_vnet.id
}

output "aks_service_subnet_cidr" {
  value = cidrsubnet(var.vnet_address_range, 2, 2)
}

output "aks_dns_service_host" {
  value = cidrhost(cidrsubnet(var.vnet_address_range, 2, 2), 2)
}
