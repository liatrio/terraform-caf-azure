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

output "ingress_host_ip" {
  value = local.ingress_host_ip
}
