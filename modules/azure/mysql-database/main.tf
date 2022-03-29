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

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "sql_pass" {
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
  name                = "${var.app_name}-${var.environment}-mysql-ep"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.snet.id

  private_service_connection {
    name                           = "${var.app_name}-${var.environment}-mysql-db-endpoint"
    is_manual_connection           = "false"
    private_connection_resource_id = azurerm_mysql_database.sql_db.id
    subresource_names              = ["mysqlServer"]
  }
}


resource "azurerm_key_vault_certificate" "ssl" {
  name         = "${var.app_name}-${var.environment}-mysql-cert"
  key_vault_id = data.azurerm_key_vault.ss_kv.id

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
        dns_names = ["${azurerm_mysql_server.db_server.name}.mysql.database.azure.com"]
      }

      subject            = "CN=${azurerm_mysql_server.db_server.name}.mysql.database.azure.com"
      validity_in_months = 12
    }
  }
}
