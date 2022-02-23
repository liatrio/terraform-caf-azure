provider "azurerm" {
  tenant_id = var.tenant_id
  features  {}
}

provider "azurerm" {
  alias           = "connectivity"
  tenant_id       = var.tenant_id
  subscription_id = var.connectivity_subscription_id
  features        {}
}

provider "azurerm" {
  alias           = "identity"
  tenant_id       = var.tenant_id
  subscription_id = var.identity_subscription_id
  features        {}
}

provider "azurerm" {
  alias           = "management"
  tenant_id       = var.tenant_id
  subscription_id = var.management_subscription_id
  features        {}
}

module "liatrio_caf_foundation" {
  source = "git@github.com:liatrio/terraform-caf-azure//foundation"
  providers = {
    azurerm.default      = azurerm
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  tenant_id                            = var.tenant_id
  group_prefix = "example"
  virtual_hub_address_cidr             = "10.130.0.0/23"
  vpn_client_pool_address_cidr         = "10.130.2.0/24"
  connectivity_apps_address_cidr       = "10.130.3.0/24"
  vpn_service_principal_application_id = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}
