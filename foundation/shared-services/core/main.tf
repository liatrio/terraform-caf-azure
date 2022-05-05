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

locals {
  shared_services_name = "shared-services-${var.environment}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.prefix}-${local.shared_services_name}-${var.location}"
  location = var.location
}
