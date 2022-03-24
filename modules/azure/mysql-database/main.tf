data "azurerm_key_vault" "ss_kv" {
  provider            = azurerm.shared_services
  name                = "var.ss_kv"
  resource_group_name = "var.ss_rg"
}

resource "random_password" "sql_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "sql_pass" {
  name         = azurerm_sql_database.sql_db.name
  value        = random_password.sql_pass.result
  key_vault_id = azurerm_key_vault.ss_kv.id
}

resource "azrurerm_keyvault_secret" "sql_conn_string" {
  name         = "${azurerm_sql_database.sql_db.name}-conn-string"
  value        = "mysql.createConnection({host: {${azurerm_sql_server.db_server.name}.mysql.database.azure.com}, user: {${azure_mysql_server.db_server.administrator_login}@${azurerm_sql_server.db_server.name}.mysql.database.azure.com}, password: {${random_password.sql_pass.result}}, database: {${azurerm_mysql_database.sql_db.name}, Port: {3306});"
  key_vault_id = azurerm_key_vault.ss_kv.id
}

resource "azurerm_mysql_server" "db_server" {
  name                         = "${var.prefix}${var.environment}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  administrator_login          = "${azurerm_sql_database.sql_db.name}_adm"
  administrator_login_password = random_password.sql_pass.result

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "db_storage_account" {
  name                     = "${var.prefix}${var.environment}${var.storage_account_name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mysql_database" "sql_db" {
  name                = var.prefix
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.db_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.db_storage_account.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.db_storage_account.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = var.environment
  }
}
