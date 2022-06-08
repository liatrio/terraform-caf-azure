data "azurerm_private_dns_zone" "key_vault" {
  provider            = azurerm.connectivity
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.connectivity_resource_group_name
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-${azurerm_key_vault.key_vault.name}"
  resource_group_name = azurerm_key_vault.key_vault.resource_group_name
  location            = azurerm_key_vault.key_vault.location
  subnet_id           = var.service_endpoints_subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = "kv-service-connection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.key_vault.id]
  }
}
