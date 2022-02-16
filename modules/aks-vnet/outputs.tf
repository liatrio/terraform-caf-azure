output "vnet_subnet_id" {
  value = tolist(azurerm_virtual_network.aks_vnet.subnet)[0].id
}