data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "vnet_rg" {
    name = var.vnet_rg_name
}

data "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

data "azurerm_subnet" "pe" {
    name                 = var.subnet_name
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    resource_group_name  = data.azurerm_resource_group.vnet_rg.name 
}

data "azurerm_resource_group" "dns_rg" {
    name = var.dns_rg_name
}

data "azurerm_private_dns_zone" "dns" {
    name                = "privatelink.azurewebsites.net"
    resource_group_name = data.azurerm_resource_group.dns_rg.name
}
