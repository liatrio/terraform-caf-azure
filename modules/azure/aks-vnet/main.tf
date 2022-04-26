terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_network_security_group" "aks_vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "aks_vnet" {
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
  network_security_group_name = azurerm_network_security_group.aks_vnet.name
}

# Create Virtual Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_range]
  tags                = var.tags
}

resource "azurerm_virtual_network_dns_servers" "aks_vnet" {
  count = length(var.connectivity_dns_servers) > 0 ? 1 : 0

  virtual_network_id = azurerm_virtual_network.aks_vnet.id
  dns_servers        = var.connectivity_dns_servers
}

resource "azurerm_subnet" "aks_nodes_and_pods" {
  name                 = var.name
  resource_group_name  = azurerm_virtual_network.aks_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [local.aks_pods_nodes_subnet]

  # This needs to be enabled for the kube-apiserver endpoint to be created
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_network_security_group_association" "aks_vnet" {
  network_security_group_id = azurerm_network_security_group.aks_vnet.id
  subnet_id                 = azurerm_subnet.aks_nodes_and_pods.id
}

resource "azurerm_subnet" "service_endpoints" {
  name                 = "service-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [local.service_endpoints_subnet]

  # This needs to be enabled for Key Vault etc service endpoints to be created
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = ["Microsoft.KeyVault"]
}

resource "azurerm_firewall" "firewall" {
  name                = "afw-${var.name}"
  location            = var.location
  

  resource_group_name = var.resource_group_name
}
