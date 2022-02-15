output "vnet_subnet_id" {
    value = tolist(azurerm_virtual_network.aksvnet.subnet)[0].id
}