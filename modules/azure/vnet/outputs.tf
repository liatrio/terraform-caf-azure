output "vnet_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet[0].id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
