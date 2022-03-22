# locals {
#   length_of_account_name = length("${var.prefix}${var.account_name}${var.environment}")
# }

resource "azurerm_sql_server" "db_server" {
  name                         = "${var.prefix}${var.environment}${var.storage_account_name}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

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

resource "azurerm_sql_database" "sql_db" {
  name                = var.prefix
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.db_server.name

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
