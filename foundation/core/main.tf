terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
      configuration_aliases = [
        azurerm.default,
        azurerm.identity,
        azurerm.management,
        azurerm.connectivity
      ]
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.22.0"
    }
  }
}