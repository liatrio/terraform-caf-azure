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
  virtual_hub_address_cidr             = "10.130.0.0/23"
  vpn_client_pool_address_cidr         = "10.130.2.0/24"
  connectivity_apps_address_cidr       = "10.130.3.0/24"
  vpn_service_principal_application_id = var.vpn_service_principal_application_id
  provision_budget_alerts              = true
  subscriptions = {
    "caf-management" : "${dependency.subscriptions.outputs.management_subscription_id}",
    "caf-connectivity" : "${dependency.subscriptions.outputs.connectivity_subscription_id}"
  }
  budget_tags        = {}
  budget_time_start  = "2022-05-01T00:00:00Z"
  budget_amounts     = { "caf-management" : 1000, "caf-connectivity" : 100 }
  budget_time_grains = { "caf-management" : "Monthly", "caf-connectivity" : "Quarterly" }
  budget_operator    = { "caf-management" : "EqualTo", "caf-connectivity" : "EqualTo" }
  budget_threshold   = { "caf-management" : 80.0, "caf-connectivity" : 80.0 }
  slack_webhook_url  = ""
  teams_webhook_url  = ""
}
