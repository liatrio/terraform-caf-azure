provider "azurerm" {
  features {}
  subscription_id = var.shared_services_subscription_id
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
  features {}
}


module "liatrio_caf_shared_services" {
  # source = "git@github.com:liatrio/terraform-caf-azure//foundation/shared-services/core?ref=examples"
  source = "../../..//foundation/shared-services/core"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  prefix                           = "example"
  connectivity_resource_group_name = "example-connectivity"
  environment                      = "prod"
  kubernetes_version               = "1.21.9"
  parent_dns_zone_name             = "azurecaf-example.liatr.io"
  vnet_address_range               = "10.133.0.0/16"
  public_dns_zone_name             = "shared-svc.azurecaf-example.liatr.io"
  vm_size                          = "standard_ds2"
  connectivity_dns_servers         = ["10.130.3.4"]
}
