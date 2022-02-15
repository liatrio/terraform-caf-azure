terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_resource_group" "aks_caf_poc" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "aks_security_group" {
  name                = "aks-security-group"
  location            = azurerm_resource_group.aks_caf_poc.location
  resource_group_name = azurerm_resource_group.aks_caf_poc.name

  tags = {
    Project = "aks-caf-poc"
  }
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
  resource_group_name         = azurerm_resource_group.aks_caf_poc.name
  network_security_group_name = azurerm_network_security_group.aks_security_group.name
}

# Create Virtual Network
resource "azurerm_virtual_network" "aksvnet" {
  name                = "aks-network"
  location            = azurerm_resource_group.aks_caf_poc.location
  resource_group_name = azurerm_resource_group.aks_caf_poc.name
  address_space       = [var.vnet_address_range]
  subnet {
    name           = "aks-subnet1"
    address_prefix = var.aks_subnet_address_range
    security_group = azurerm_network_security_group.aks_security_group.id
  }
  tags = {
    Project = "aks-caf-poc"
  }
}
