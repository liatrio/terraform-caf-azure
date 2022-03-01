terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_dns_zone" "public_dns_zone" {
  name                = var.root_dns_zone
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
