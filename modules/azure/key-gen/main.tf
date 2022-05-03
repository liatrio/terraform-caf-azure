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

resource "azurerm_key_vault_key" "key" {
  count = var.vault_key_to_create != {} ? 1 : 0

  name         = var.vault_key_to_create.name
  key_vault_id = var.key_vault_id

  # Defaulting to EC key type as elliptical curve encryption is more secure
  # than RSA and has no mathematical means of breaking the encryption.
  key_type        = "EC"
  curve           = can(var.vault_key_to_create.curve) ? var.vault_key_to_create.curve : "P-384"
  expiration_date = can(var.vault_key_to_create.expiration_date) ? var.vault_key_to_create.expiration_date : formatdate("Y-m-d'T'H:M:S'Z'", timeadd(timestamp(), "8760h"))
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "encryption_set" {
  count = var.vault_key_to_create != {} ? 1 : 0

  name                      = var.vault_key_to_create.name
  auto_key_rotation_enabled = true
  resource_group_name       = var.resource_group_name
  location                  = var.location
  key_vault_key_id          = azurerm_key_vault_key.key[0].id

  identity {
    type = "SystemAssigned"
  }
}
