terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
      configuration_aliases = [
        azurerm.connectivity
    ] }
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  name                  = var.dns_zone_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.linked_virtual_network_id
}
