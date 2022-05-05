provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = var.identity_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
  features {}
}

module "liatrio_caf_foundation" {
  # source = "git@github.com:liatrio/terraform-caf-azure//foundation/core"
  source = "../../..//foundation/core"
  providers = {
    azurerm.default      = azurerm
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  location      = "centralus"
  root_dns_zone = "azurecaf-example.liatr.io"
  root_dns_tags = {
    features = "caf-example_root_dns"
  }
  prefix                               = "example"
  environment                          = "dev"
  virtual_hub_address_cidr             = "10.130.0.0/23"
  vpn_client_pool_address_cidr         = "10.130.2.0/24"
  connectivity_apps_address_cidr       = "10.130.3.0/24"
  vpn_service_principal_application_id = var.vpn_service_principal_application_id
}
