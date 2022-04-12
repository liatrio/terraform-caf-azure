
module "aks-lz-dev_public_dns_zone" {
  providers = {
    azurerm                 = azurerm
    azurerm.parent_dns_zone = azurerm.connectivity
    azurerm.connectivity    = azurerm.connectivity

  }

  source = "../../../modules/azure/public-dns-zone"

  count = var.external_app ? 1 : 0

  resource_group_name                 = azurerm_resource_group.lz_resource_group.name
  dns_zone_name                       = var.dns_zone_name
  parent_dns_zone_name                = var.parent_dns_zone_name
  parent_dns_zone_resource_group_name = var.connectivity_resource_group_name
}
