# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-billing-alert-func-core-${var.location}"
  location = var.location
  tags     = var.budget_tags
}

resource "azurerm_storage_account" "func" {
  name                     = format("st%s", replace("billing-alert-func", "-", "")) # using just billing-alert-func for character limits
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage.tier
  account_replication_type = var.storage.replication_type
  min_tls_version          = "TLS1_2"
  tags                     = var.budget_tags

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }

    hour_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 7
    }

    minute_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }
}

resource "azurerm_storage_queue" "main" {
  name                 = "stq-billing-alert-func-core-${var.location}"
  storage_account_name = azurerm_storage_account.func.name
}

resource "azurerm_storage_container" "deployments" {
  name                  = "stc-billing-alert-func-core-${var.location}"
  storage_account_name  = azurerm_storage_account.func.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = "stb-billing-alert-func-core-${var.location}"
  storage_account_name   = azurerm_storage_account.func.name
  storage_container_name = azurerm_storage_container.deployments.name
  type                   = "Block"
  content_type           = "application/zip"

  lifecycle {
    ignore_changes = [
      content_md5,
    ]
  }
}

locals {
  start  = timestamp()
  expiry = timeadd(local.start, "26298h") #Represents time from starting date plus number in quotes in hours
}

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.func.primary_connection_string
  container_name    = azurerm_storage_container.deployments.name

  start  = local.start
  expiry = local.expiry

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}
