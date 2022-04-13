# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/main.tf

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.slack_func_identifier}"
  location = var.location
}

resource "azurerm_storage_account" "func" {
  name                     = format("st%s", replace(var.slack_func_identifier, "-", ""))
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage.tier
  account_replication_type = var.storage.replication_type
}

resource "azurerm_app_service_plan" "main" {
  name                = "plan-${var.slack_func_identifier}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = var.app_service_plan.tier
    size = var.app_service_plan.size
  }
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${var.slack_func_identifier}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "Node.JS"
  tags                = {}
}

resource "azurerm_function_app" "main" {
  name                       = "func-${var.slack_func_identifier}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  os_type                    = "linux"

  app_service_plan_id        = azurerm_app_service_plan.main.id
  storage_account_name       = azurerm_storage_account.func.name
  storage_account_access_key = azurerm_storage_account.func.primary_access_key
  version                    = "~3"

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main.instrumentation_key
    "FUNCTIONS_WORKER_RUNTIME"       = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~14"
    "slackWebhookUrl"                = var.slack_webhook_url
  }
}
