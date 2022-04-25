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
  count = var.to_provision == true ? 1 : 0
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
    count = var.to_provision == true ? 1 : 0
    name = "slack-alert-function-releases"
    storage_account_name = "${azurerm_storage_account.func[count.index].name}"
    container_access_type = "private"
}

data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "${path.module}/slack-function-app"
  output_path = "slack-function-app.zip"
}

resource "azurerm_storage_blob" "storage_blob" {
  count = var.to_provision == true ? 1 : 0
  name = "${filesha256(data.archive_file.file_function_app.output_path)}"
  storage_account_name = azurerm_storage_account.func[count.index].name
  storage_container_name = azurerm_storage_container.deployments[count.index].name
  type = "Block"
  source = data.archive_file.file_function_app.output_path
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
  count                      = var.to_provision == true ? 1 : 0
  name                       = "func-${var.slack_func_identifier}"
  resource_group_name        = azurerm_resource_group.main[count.index].name
  location                   = azurerm_resource_group.main[count.index].location
  os_type                    = "linux"

  app_service_plan_id        = azurerm_app_service_plan.main[count.index].id
  storage_account_name       = azurerm_storage_account.func[count.index].name
  storage_account_access_key = azurerm_storage_account.func[count.index].primary_access_key
  version                    = "~4"

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main[count.index].instrumentation_key
    "FUNCTIONS_WORKER_RUNTIME"    = "node",
    "slackWebhookUrl"             = var.slack_webhook_url,
    "WEBSITE_RUN_FROM_PACKAGE"    = "https://${azurerm_storage_account.func[count.index].name}.blob.core.windows.net/${azurerm_storage_container.deployments[count.index].name}/${azurerm_storage_blob.storage_blob[count.index].name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas[count.index].sas}",
    "AzureWebJobsDisableHomepage" = "true",
  }

  site_config {
    linux_fx_version          = "node|16"
    use_32_bit_worker_process = false
  }
}

resource "azurerm_monitor_action_group" "example" {
  count               = var.to_provision == true ? 1 : 0
  name                = "action-group-${var.slack_func_identifier}"
  resource_group_name = azurerm_resource_group.main[count.index].name
  short_name          = "slack-ag"

  webhook_receiver {
    name                    = "callazurefuncapi"
    # Using string interpolation to get full hostname of function. "/api/slack-budget-alert" doesn't change
    service_uri             = "https://${azurerm_function_app.main[count.index].default_hostname}/api/slack-budget-alert" // TODO: use variable instead of "/slack-budget-alert/"
    use_common_alert_schema = false
  }
}

// TODO: move this into a separate module so we can send a list of subscription ids to create a number of budgets
// TODO: define budget alerts for other subscriptions (CAF-Connectivity, Landing zones, ...variable number)

resource "azurerm_consumption_budget_subscription" "example" {
  count           = var.to_provision == true ? 1 : 0
  name            = "budget-${var.slack_func_identifier}"
  subscription_id = data.azurerm_subscription.subscription.id
  amount          = 1000 // TODO: turn this into a variable
  time_grain      = "Monthly" // TODO: turn into variable with choices

  time_period {
    start_date = "2022-06-01T00:00:00Z" 
    # end_date   = "2022-07-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 1.0 // TODO: variable
    operator  = "EqualTo" // TODO: variable?

    contact_groups = [
      azurerm_monitor_action_group.example[count.index].id,
    ]
  }
}