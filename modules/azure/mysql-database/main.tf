terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
      configuration_aliases = [
        azurerm.shared_services
      ]
    }
  }
}

resource "random_password" "sql_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "sql_pass" {
  name            = azurerm_sql_database.sql_db.name
  value           = random_password.sql_pass.result
  key_vault_id    = azurerm_key_vault.shrdsvcs_kv.id
  content_type    = "password"
  expiration_date = "2023-12-31T00:00:00Z"
}

resource "azurerm_keyvault_secret" "sql_conn_string" {
  name            = "${azurerm_sql_database.sql_db.name}-conn-string"
  value           = "mysql.createConnection({host: {${azurerm_sql_server.db_server.name}.mysql.database.azure.com}, user: {${azure_mysql_server.db_server.administrator_login}@${azurerm_sql_server.db_server.name}.mysql.database.azure.com}, password: {${random_password.sql_pass.result}}, database: {${azurerm_mysql_database.sql_db.name}, Port: {3306});"
  key_vault_id    = azurerm_key_vault.shrdsvcs_kv.id
  content_type    = "string"
  expiration_date = "2023-12-31T00:00:00Z"
}

resource "azurerm_mysql_server" "db_server" {
  name                             = "${var.prefix}${var.environment}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  administrator_login              = "${azurerm_sql_database.sql_db.name}_adm"
  administrator_login_password     = random_password.sql_pass.result
  ssl_minimal_tls_version_enforced = "TLS1_2"
  ssl_enforcement_enabled          = true
  public_network_access_enabled    = false


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
  min_tls_version          = "TLS1_2"
  queue_properties {

    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 10
    }

    hour_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 10
    }

    minute_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }

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

resource "azurerm_private_endpoint" "db_endpoint" {
  name                = "${var.prefix}${var.environment}mysql-ep"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.snet.id

  private_service_connection {
    name                                   = "${var.prefix}${var.environment}mysql-db-endpoint"
    is_is_manual_connection                = "false"
    private_private_connection_resource_id = azurerm_mysql_database.sql_db.id
    subresource_names                      = ["sqlServer"]
  }
}



resource "azurerm_key_vault_certificate" "ssl" {
  name         = "mysql-cert"
  key_vault_id = azurerm_key_vault.shrdsvcs_kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["${azurerm_sql_server.db_server.name}.mysql.database.azure.com"]
      }

      subject            = "CN=${azurerm_sql_server.db_server.name}.mysql.database.azure.com"
      validity_in_months = 12
    }
  }
}
