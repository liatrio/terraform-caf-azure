terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
}

resource "azurerm_network_security_group" "vnet_nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "vnet_nsg_rules" {
  for_each = {
    for rule_name, rule in local.nsgrules : rule_name => rule
    if rule.include
  }

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
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_range]
  tags                = var.tags
}

resource "azurerm_virtual_network_dns_servers" "vnet" {
  count = length(var.connectivity_dns_servers) > 0 ? 1 : 0

  virtual_network_id = azurerm_virtual_network.vnet.id
  dns_servers        = var.connectivity_dns_servers
}

resource "azurerm_subnet_network_security_group_association" "vnet" {
  for_each                  = azurerm_virtual_network.vnet.subnet.*.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
  subnet_id                 = each.value.id
}
