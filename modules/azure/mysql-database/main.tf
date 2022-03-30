terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
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
    last_updated = "2022-03-29"
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

resource "azurerm_mysql_server" "db_server" {
  name                             = "${var.app_name}-${var.environment}-db-server"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  administrator_login              = local.db_server_admin_login
  administrator_login_password     = random_password.sql_pass.result
  ssl_minimal_tls_version_enforced = "TLS1_2"
  ssl_enforcement_enabled          = true
  public_network_access_enabled    = false


  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_mysql_database" "sql_db" {
  name                = "${var.app_name}-mysql-db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.db_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_private_endpoint" "db_endpoint" {
  provider            = azurerm.connectivity
  name                = "${var.app_name}-${var.environment}-mysql-ep"
  location            = var.location
  resource_group_name = var.connectivity_resource_group
  subnet_id           = data.azurerm_subnet.snet.id

  private_service_connection {
    name                           = "${var.app_name}-${var.environment}-mysql-privateserviceconnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mysql_server.db_server.id
    subresource_names              = [ "mysqlServer" ]
  }
}
