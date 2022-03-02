terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}

resource "azurerm_dns_zone" "public_dns_zone" {
  name                = var.root_dns_zone
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_dns_ns_record" "ns_record" {
  provider            = azurerm.connectivity
  count               = var.parent_dns_zone_name == "" ? 0 : 1
  name                = split(".", var.root_dns_zone)[0]
  zone_name           = var.parent_dns_zone_name
  resource_group_name = var.parent_dns_zone_resource_group_name
  ttl                 = 300

  records = azurerm_dns_zone.public_dns_zone.name_servers

  tags = var.tags
}
