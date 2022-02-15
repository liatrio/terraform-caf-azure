terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_resource_group" "aks" {
  name     = var.name
  location = var.location
}

resource "azurerm_network_security_group" "aks_security_group" {
  name                = var.name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "aks_sec_rules" {
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  description                 = each.value.description
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.aks.name
  network_security_group_name = azurerm_network_security_group.aks_security_group.name
}

# Create Virtual Network
resource "azurerm_virtual_network" "aksvnet" {
  name                = var.name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = [var.vnet_address_range]
  subnet {
    name           = var.name
    address_prefix = var.aks_subnet_address_range
    security_group = azurerm_network_security_group.aks_security_group.id
  }
  tags = var.tags
}
