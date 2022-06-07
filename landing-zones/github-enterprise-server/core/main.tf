terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 2.96.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}

resource "azurerm_resource_group" "github_enterprise_server" {
  name     = "ghe-server-rg"
  location = var.location
}
