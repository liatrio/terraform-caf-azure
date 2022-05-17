terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
      configuration_aliases = [
        azurerm.shared_services,
        azurerm.connectivity
      ]
    }
  }
}

resource "random_password" "sql_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    last_updated = var.database_password_change_date
  }
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "sql_pass" {
  provider     = azurerm.shared_services
  name         = azurerm_mysql_database.sql_db.name
  value        = random_password.sql_pass.result
  key_vault_id = data.azurerm_key_vault.ss_kv.id
  content_type = "password"
}

#tfsec:ignore:azure-database-secure-tls-policy
#tfsec:ignore:azure-database-enable-ssl-enforcement
resource "azurerm_mysql_server" "db_server" {
  name                             = var.app_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  administrator_login              = var.app_name
  administrator_login_password     = random_password.sql_pass.result
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
  ssl_enforcement_enabled          = false
  public_network_access_enabled    = false
  sku_name                         = "GP_Gen5_2"
  storage_mb                       = 5120
  version                          = "5.7"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_mysql_database" "sql_db" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.db_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_private_endpoint" "db_endpoint" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.snet.id

  private_service_connection {
    name                           = var.app_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mysql_server.db_server.id
    subresource_names              = ["mysqlServer"]
  }

  private_dns_zone_group {
    name = "privatelink-dns-zones"

    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.privatelink_mysql_dns_zone.id
    ]
  }

}
