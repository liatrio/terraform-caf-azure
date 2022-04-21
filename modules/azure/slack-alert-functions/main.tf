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

resource "azurerm_storage_container" "deployments" {
    name = "slack-alert-function-releases"
    storage_account_name = "${azurerm_storage_account.func.name}"
    container_access_type = "private"
}

data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "${path.module}/slack-function-app"
  output_path = "slack-function-app.zip"
}

resource "azurerm_storage_blob" "storage_blob" {
  name = "${filesha256(data.archive_file.file_function_app.output_path)}"
  storage_account_name = azurerm_storage_account.func.name
  storage_container_name = azurerm_storage_container.deployments.name
  type = "Block"
  source = data.archive_file.file_function_app.output_path
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

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.func.primary_connection_string
  container_name    = azurerm_storage_container.deployments.name

  start = "2022-01-01T00:00:00Z"
  expiry = "2023-01-01T00:00:00Z"

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
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~16"
    "slackWebhookUrl"                = var.slack_webhook_url
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${azurerm_storage_account.func.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas}",
    # "AzureWebJobsStorage"            = ""
  }
}
