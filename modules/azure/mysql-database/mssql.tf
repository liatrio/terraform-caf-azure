resource "random_password" "mssql_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  count            = var.mssql_enabled == "true" ? 1 : 0
  keepers = {
    last_updated = "2022-03-29"
  }
}

resource "azurerm_key_vault_secret" "mssql_pass" {
  provider     = azurerm.shared_services
  name         = azurerm_mysql_database.sql_db.name
  value        = random_password.sql_pass.result
  key_vault_id = data.azurerm_key_vault.ss_kv.id
  content_type = "password"
  count        = var.mssql_enabled
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = "sql-${var.app}-${var.environment}-${var.location}-0${count.index}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.mssql_server_version
  administrator_login          = var.mssql_admin_user
  administrator_login_password = random_password.mssql_pass.result
  minimum_tls_version          = "1.2"
  count                        = var.mssql_enabled == "true" ? 1 : 0
}

resource "azurerm_mssql_database" "mssql_db_[each.key]"  {
  for_each       = var.mssql_database_map
  name           = each.value.db_name
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = each.value.collation
  license_type   = "LicenseIncluded"
  max_size_gb    = each.value.size
  read_scale     = true
  sku_name       = each.value.sku
  zone_redundant = false
}

resource "azurerm_private_endpoint" "db_endpoint" {
  name                = "pe-${var.app}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.snet.id
  count               = var.mssql_enabled == "true" ? 1 : 0

  private_service_connection {
    name                           = "pec-${var.app}-${var.environment}-${var.location}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    subresource_names              = ["sqlServer"]
  }
}
  