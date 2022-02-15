output "vnet_subnet_id" {
    value = tolist(azurerm_virtual_network.aksvnet.subnet)[0].id
}

output "resource_group_name" {
    value = azurerm_resource_group.aks.name
}