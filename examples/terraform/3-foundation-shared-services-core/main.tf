provider "azurerm" {
  features {}
  subscription_id = var.shared_services_subscription_id
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {}
}

module "liatrio_caf_shared_services" {
  # source = "git@github.com:liatrio/terraform-caf-azure//foundation/shared-services/core?ref=examples"
  source = "../../../..//foundation/shared-services/core"
  providers = {
    azurerm      = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  prefix = "example"
  connectivity_resource_group_name = "example-connectivity"
  environment = "prod"
  kubernetes_version = "1.21.9"
  parent_dns_zone_name = "azurecaf-example.liatr.io"
  vnet_address_range = "10.133.0.0/16"
  public_dns_zone_name = "shared-svc.azurecaf-example.liatr.io"
  vm_size = "Standard_D1_v2"
  # tenant_id                            = var.tenant_id
  # group_prefix                         = "example"
  # virtual_hub_address_cidr             = "10.130.0.0/23"
  # vpn_client_pool_address_cidr         = "10.130.2.0/24"
  # connectivity_apps_address_cidr       = "10.130.3.0/24"
  # vpn_service_principal_application_id = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}
