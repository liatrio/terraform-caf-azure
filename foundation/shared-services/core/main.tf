terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management
      ]
    }
  }
}

locals {
  shared_services_name = "core-shared-services"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.prefix}-${local.shared_services_name}-${var.env}-${var.location}"
  location = var.location
}
