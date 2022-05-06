# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

data "azurerm_client_config" "azurerm_provider" {
  provider = azurerm
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.func_identifier}"
  location = var.location
  tags     = var.budget_tags
}

resource "azurerm_storage_account" "func" {
  name                     = format("st%s", replace(var.func_identifier, "-", ""))
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
  name                 = "funcqueue"
  storage_account_name = azurerm_storage_account.func.name
}

resource "azurerm_storage_container" "deployments" {
  name                  = "billing-alert-function-releases"
  storage_account_name  = azurerm_storage_account.func.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = "billing-alert-function-blob"
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

resource "azurerm_app_service_plan" "main" {
  name                = "plan-${var.func_identifier}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true
  tags                = var.budget_tags

  sku {
    tier = var.app_service_plan.tier
    size = var.app_service_plan.size
  }

  lifecycle {
    ignore_changes = [
      kind,
    ]
  }
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${var.func_identifier}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "Node.JS"
  tags                = var.budget_tags
}

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.func.primary_connection_string
  container_name    = azurerm_storage_container.deployments.name

  start  = var.budget_time_start
  expiry = "2024-01-01T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

resource "azurerm_function_app" "main" {
  name                = "func-${var.func_identifier}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "linux"
  https_only          = true

  app_service_plan_id        = azurerm_app_service_plan.main.id
  storage_account_name       = azurerm_storage_account.func.name
  storage_account_access_key = azurerm_storage_account.func.primary_access_key
  version                    = "~4"
  tags                       = var.budget_tags

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main.instrumentation_key
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "slackWebhookUrl"                = var.slack_webhook_url,
    "teamsWebhookUrl"                = var.teams_webhook_url,
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${azurerm_storage_account.func.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas}",
    "AzureWebJobsDisableHomepage"    = "true",
  }

  site_config {
    linux_fx_version          = "node|16"
    use_32_bit_worker_process = false
  }
}

module "subscription_budgets" {
  providers = {
    azurerm = azurerm
  }
  source = "./subscription-budgets"

  enable_slack        = var.slack_webhook_url != "" ? true : false
  enable_teams        = var.teams_webhook_url != "" ? true : false
  subscriptions       = var.subscriptions
  budget_time_start   = var.budget_time_start
  budget_threshold    = var.budget_threshold
  budget_operator     = var.budget_operator
  budget_time_grains  = var.budget_time_grains
  budget_amounts      = var.budget_amounts
  resource_group_name = azurerm_resource_group.main.name
  default_hostname    = azurerm_function_app.main.default_hostname
  func_identifier     = var.func_identifier
  budget_tags         = var.budget_tags
}
