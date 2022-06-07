data "azurerm_virtual_network" "connectivity_vnet" {
  provider            = azurerm.connectivity
  name                = "connectivity-apps"
  resource_group_name = var.connectivity_resource_group
}

module "ghe_internal_private_dns_zone" {
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  source = "../../../modules/azure/private-dns-zone"

  dns_zone_name             = var.github_enterprise_server_hostname
  location                  = azurerm_resource_group.github_enterprise_server.location
  resource_group_name       = azurerm_resource_group.github_enterprise_server.name
  linked_virtual_network_id = data.azurerm_virtual_network.connectivity_vnet.id
}

resource "azurerm_private_dns_a_record" "github_enterprise_server" {
  for_each            = toset(["@", "*"])
  name                = each.value
  resource_group_name = azurerm_resource_group.github_enterprise_server.name
  ttl                 = 360
  zone_name           = module.ghe_internal_private_dns_zone.dns_zone_name
  records             = [
    azurerm_network_interface.github_enterprise_server.private_ip_address
  ]
}
