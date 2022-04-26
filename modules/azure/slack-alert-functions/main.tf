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

data "azurerm_subscription" "subscription" {
  subscription_id = data.azurerm_client_config.azurerm_provider.subscription_id
}

resource "azurerm_resource_group" "main" {
  count    = var.to_provision == true ? 1 : 0
  name     = "rg-${var.slack_func_identifier}"
  location = var.location
}

resource "azurerm_storage_account" "func" {
  count                    = var.to_provision == true ? 1 : 0
  name                     = format("st%s", replace(var.slack_func_identifier, "-", ""))
  resource_group_name      = azurerm_resource_group.main[count.index].name
  location                 = azurerm_resource_group.main[count.index].location
  account_tier             = var.storage.tier
  account_replication_type = var.storage.replication_type
}

resource "azurerm_storage_container" "deployments" {
  count                 = var.to_provision == true ? 1 : 0
  name                  = "slack-alert-function-releases"
  storage_account_name  = azurerm_storage_account.func[count.index].name
  container_access_type = "private"
}

data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "${path.module}/slack-function-app"
  output_path = "slack-function-app.zip"
}

resource "azurerm_storage_blob" "storage_blob" {
  count                  = var.to_provision == true ? 1 : 0
  name                   = filesha256(data.archive_file.file_function_app.output_path)
  storage_account_name   = azurerm_storage_account.func[count.index].name
  storage_container_name = azurerm_storage_container.deployments[count.index].name
  type                   = "Block"
  source                 = data.archive_file.file_function_app.output_path
}

resource "azurerm_app_service_plan" "main" {
  count               = var.to_provision == true ? 1 : 0
  name                = "plan-${var.slack_func_identifier}"
  location            = azurerm_resource_group.main[count.index].location
  resource_group_name = azurerm_resource_group.main[count.index].name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = var.app_service_plan.tier
    size = var.app_service_plan.size
  }
}

resource "azurerm_application_insights" "main" {
  count               = var.to_provision == true ? 1 : 0
  name                = "appi-${var.slack_func_identifier}"
  location            = azurerm_resource_group.main[count.index].location
  resource_group_name = azurerm_resource_group.main[count.index].name
  application_type    = "Node.JS"
  tags                = {}
}

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  count             = var.to_provision == true ? 1 : 0
  connection_string = azurerm_storage_account.func[count.index].primary_connection_string
  container_name    = azurerm_storage_container.deployments[count.index].name

  start  = "2022-01-01T00:00:00Z"
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
  count               = var.to_provision == true ? 1 : 0
  name                = "func-${var.slack_func_identifier}"
  resource_group_name = azurerm_resource_group.main[count.index].name
  location            = azurerm_resource_group.main[count.index].location
  os_type             = "linux"

  app_service_plan_id        = azurerm_app_service_plan.main[count.index].id
  storage_account_name       = azurerm_storage_account.func[count.index].name
  storage_account_access_key = azurerm_storage_account.func[count.index].primary_access_key
  version                    = "~4"

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main[count.index].instrumentation_key
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "slackWebhookUrl"                = var.slack_webhook_url,
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${azurerm_storage_account.func[count.index].name}.blob.core.windows.net/${azurerm_storage_container.deployments[count.index].name}/${azurerm_storage_blob.storage_blob[count.index].name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas[count.index].sas}",
    "AzureWebJobsDisableHomepage"    = "true",
  }

  site_config {
    linux_fx_version          = "node|16"
    use_32_bit_worker_process = false
  }
}

module "subscription_budgets" {
  # If to_provision is set to true, run this module for how many subscriptions are passed in
  count = var.to_provision == true ? 1 : 0
  providers = {
    azurerm = azurerm
  }
  source = "./subscription-budgets"

  subscriptions         = var.subscriptions
  budget_threshold      = var.budget_threshold
  budget_operator       = var.budget_operator
  budget_time_frames    = var.budget_time_frames
  budget_amounts        = var.budget_amounts
  resource_group_name   = azurerm_resource_group.main[count.index].name
  default_hostname      = azurerm_function_app.main[count.index].default_hostname
  slack_func_identifier = var.slack_func_identifier
  // TODO: have it consume list of subscription ids, budget amounts, and time frames
}
