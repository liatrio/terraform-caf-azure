terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = var.azure_paas_private_dns_zones
  name                = each.value
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    resource = each.key
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  for_each              = azurerm_private_dns_zone.private_dns_zone
  name                  = each.value.name
  private_dns_zone_name = each.value.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.linked_virtual_network_id
}
