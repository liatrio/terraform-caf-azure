#tfsec:ignore:azure-keyvault-no-purge
resource "azurerm_key_vault" "key_vault" {
  name                      = "${var.prefix}-${var.environment}"
  location                  = azurerm_resource_group.resource_group.location
  resource_group_name       = azurerm_resource_group.resource_group.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [module.aks_vnet.service_endpoints_subnet_id]
  }

  sku_name = "standard"
}

data "azurerm_private_dns_zone" "key_vault" {
  provider            = azurerm.connectivity
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.connectivity_resource_group_name
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "kv-endpoint"
  resource_group_name = azurerm_key_vault.key_vault.resource_group_name
  location            = azurerm_key_vault.key_vault.location
  subnet_id           = module.aks_vnet.service_endpoints_subnet_id

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
