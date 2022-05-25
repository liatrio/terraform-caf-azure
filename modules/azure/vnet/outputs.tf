output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_subnet_id" {
  value = azurerm_subnet.subnet.id
}
