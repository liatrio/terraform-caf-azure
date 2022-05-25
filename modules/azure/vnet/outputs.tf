output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_subnet_ids" {
  value = azurerm_virtual_network.vnet.subnet.*.id
}
