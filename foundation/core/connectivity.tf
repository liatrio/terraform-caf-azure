module "connectivity" {
  providers = {
    azurerm              = azurerm.connectivity
    azurerm.connectivity = azurerm.connectivity
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
  group_prefix                         = var.group_prefix
  connectivity_id                      = data.azurerm_subscription.connectivity.subscription_id
  connectivity_policy_sets             = var.connectivity_policy_sets
}
