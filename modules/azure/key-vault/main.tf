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

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_key" "generated" {
  for_each = var.vault_keys

  name         = each.value.name
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  key_opts     = each.value.key_opts
}

resource "azurerm_disk_encryption_set" "generated" {
  for_each = {
    for k, v in var.vault_keys : k => v
    if v.used_for_disk_encryption == true
  }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.generated[each.key].id

  identity {
    type = "SystemAssigned"
  }
}
