terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = "kv-${var.workload}-${var.environment}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  tags                        = var.tags
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "Get",
      "List",
      "Update",
    ]

    key_permissions = [
      "Get",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "List",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Get",
      "Delete",
      "List",
      "Set",
    ]

    storage_permissions = [
      "Get",
      "Delete",
      "List",
      "RegenerateKey",
      "Set",
      "Update",
    ]
  }
}
