output "vnet_subnet_id" {
  value = tolist(azurerm_virtual_network.aks_vnet.subnet)[0].id
}

output "vnet_id" {
  value = azurerm_virtual_network.aks_vnet.id
}