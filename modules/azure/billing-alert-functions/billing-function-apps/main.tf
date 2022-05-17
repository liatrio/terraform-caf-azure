terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
}

resource "azurerm_service_plan" "main" {
  name                = "plan-${var.func_identifier}-core-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_plan.size
  tags                = var.budget_tags

  lifecycle {
    ignore_changes = [
      kind,
    ]
  }
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${var.func_identifier}-core-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "Node.JS"
  tags                = var.budget_tags
}

resource "azurerm_linux_function_app" "main" {
  # name doesn't have env or location to fit hostname 32 character limit
  name                = "func-${var.func_identifier}"
  resource_group_name = var.resource_group_name
  location            = var.location
  https_only          = true

  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_primary_key
  tags                       = var.budget_tags

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main.instrumentation_key
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "slackWebhookUrl"                = var.slack_webhook_url,
    "teamsWebhookUrl"                = var.teams_webhook_url,
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/${var.storage_blob_name}${var.storage_blob_sas}",
    "AzureWebJobsDisableHomepage"    = "true",
  }

  site_config {
    use_32_bit_worker = false

    application_stack {
      node_version = 16
    }
  }
}

locals {
  enable_slack = var.slack_webhook_url == "" ? false : true
  enable_teams = var.teams_webhook_url == "" ? false : true
}

resource "azurerm_monitor_action_group" "slack" {
  count               = local.enable_slack ? 1 : 0
  name                = "ag-slack-${var.func_identifier}-core-${var.location}"
  resource_group_name = var.resource_group_name
  short_name          = "slack-ag"
  tags                = var.budget_tags

  webhook_receiver {
    name = "callazurefuncapi"
    # Using string interpolation to get full hostname of function. 
    # slack-budget-alert comes from the package directory inside the function
    service_uri             = "https://${azurerm_linux_function_app.main.default_hostname}/api/slack-budget-alert"
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_action_group" "teams" {
  count               = local.enable_teams ? 1 : 0
  name                = "ag-teams-${var.func_identifier}-core-${var.location}"
  resource_group_name = var.resource_group_name
  short_name          = "teams-ag"
  tags                = var.budget_tags

  webhook_receiver {
    name = "callazurefuncapi"
    # Using string interpolation to get full hostname of function. 
    # teams-budget-alert comes from the package directory inside the function
    service_uri             = "https://${azurerm_linux_function_app.main.default_hostname}/api/teams-budget-alert"
    use_common_alert_schema = false
  }
}

locals {
  slack_id = local.enable_slack ? azurerm_monitor_action_group.slack[0].id : ""
  teams_id = local.enable_teams ? azurerm_monitor_action_group.teams[0].id : ""
}
