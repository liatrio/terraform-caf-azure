output "vnet_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
