module "shared_services_public_dns_zone" {
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }
  source                              = "../../../modules/azure/public-dns-zone"
  resource_group_name                 = azurerm_resource_group.resource_group.name
  root_dns_zone                       = var.public_dns_zone_name
  parent_dns_zone_name                = var.parent_dns_zone_name
  parent_dns_zone_resource_group_name = var.connectivity_resource_group_name
}
