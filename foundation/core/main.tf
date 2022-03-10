terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
      configuration_aliases = [
        azurerm.default,
        azurerm.identity,
        azurerm.management,
        azurerm.connectivity
      ]
    }
  }
}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

data "azurerm_subscription" "management" {
  subscription_id = data.azurerm_client_config.management.subscription_id
}

data "azurerm_client_config" "identity" {
  provider = azurerm.identity
}

data "azurerm_subscription" "identity" {
  subscription_id = data.azurerm_client_config.identity.subscription_id
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_subscription" "connectivity" {
  subscription_id = data.azurerm_client_config.connectivity.subscription_id
}

module "connectivity" {
  providers = {
    azurerm              = azurerm.connectivity
  }
  source                               = "./connectivity"
  location                             = var.location
  virtual_hub_address_cidr             = var.virtual_hub_address_cidr
  vpn_client_pool_address_cidr         = var.vpn_client_pool_address_cidr
  connectivity_apps_address_cidr       = var.connectivity_apps_address_cidr
  tenant_id                            = var.tenant_id
  prefix                               = var.group_prefix
  vpn_service_principal_application_id = var.vpn_service_principal_application_id
  root_dns_zone                        = var.root_dns_zone
  root_dns_tags                        = var.root_dns_tags
}
