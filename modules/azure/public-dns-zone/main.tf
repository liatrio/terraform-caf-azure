terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
      configuration_aliases = [
        azurerm.parent_dns_zone,
        azurerm.connectivity
      ]
    }
  }
}

resource "azurerm_dns_zone" "public_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_dns_ns_record" "ns_record" {
  provider            = azurerm.parent_dns_zone
  count               = var.parent_dns_zone_name == "" ? 0 : 1
  name                = split(".", var.dns_zone_name)[0]
  zone_name           = var.parent_dns_zone_name
  resource_group_name = var.parent_dns_zone_resource_group_name
  ttl                 = 300

  records = azurerm_dns_zone.public_dns_zone.name_servers

  tags = var.tags
}
