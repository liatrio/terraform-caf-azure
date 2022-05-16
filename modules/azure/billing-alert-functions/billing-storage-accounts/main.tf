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

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.func_identifier}-${var.env}-${var.location}"
  location = var.location
  tags     = var.budget_tags
}

resource "azurerm_storage_account" "func" {
  name                     = format("st%s", replace(var.func_identifier, "-", "")) # using just func_identifier for character limits
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
  name                 = "stq-${var.func_identifier}-${var.env}-${var.location}"
  storage_account_name = azurerm_storage_account.func.name
}

resource "azurerm_storage_container" "deployments" {
  name                  = "stc-${var.func_identifier}-${var.env}-${var.location}"
  storage_account_name  = azurerm_storage_account.func.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = "stb-${var.func_identifier}-${var.env}-${var.location}"
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

# resource "azurerm_app_service_plan" "main" {
#   name                = "plan-${var.func_identifier}-${var.env}-${var.location}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   kind                = "Linux"
#   reserved            = true
#   tags                = var.budget_tags

#   sku {
#     tier = var.app_service_plan.tier
#     size = var.app_service_plan.size
#   }

#   lifecycle {
#     ignore_changes = [
#       kind,
#     ]
#   }
# }

# resource "azurerm_application_insights" "main" {
#   name                = "appi-${var.func_identifier}-${var.env}-${var.location}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   application_type    = "Node.JS"
#   tags                = var.budget_tags
# }

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.func.primary_connection_string
  container_name    = azurerm_storage_container.deployments.name

  start  = var.sas_time_start
  expiry = var.sas_time_end

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

# resource "azurerm_function_app" "main" {
#   name                = "func-${var.func_identifier}-${var.env}-${var.location}"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   os_type             = "linux"
#   https_only          = true

#   app_service_plan_id        = azurerm_app_service_plan.main.id
#   storage_account_name       = azurerm_storage_account.func.name
#   storage_account_access_key = azurerm_storage_account.func.primary_access_key
#   version                    = "~4"
#   tags                       = var.budget_tags

#   app_settings = {
#     "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main.instrumentation_key
#     "FUNCTIONS_WORKER_RUNTIME"       = "node",
#     "slackWebhookUrl"                = var.slack_webhook_url,
#     "teamsWebhookUrl"                = var.teams_webhook_url,
#     "WEBSITE_RUN_FROM_PACKAGE"       = "https://${azurerm_storage_account.func.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas}",
#     "AzureWebJobsDisableHomepage"    = "true",
#   }

#   site_config {
#     linux_fx_version          = "node|16"
#     use_32_bit_worker_process = false
#   }
# }

# locals {
#   enable_slack = var.slack_webhook_url == "" ? false : true
#   enable_teams = var.teams_webhook_url == "" ? false : true
# }

# resource "azurerm_monitor_action_group" "slack" {
#   count               = local.enable_slack ? 1 : 0
#   name                = "ag-slack-${var.func_identifier}-${var.env}-${var.location}"
#   resource_group_name = azurerm_resource_group.main.name
#   short_name          = "slack-ag"
#   tags                = var.budget_tags

#   webhook_receiver {
#     name = "callazurefuncapi"
#     # Using string interpolation to get full hostname of function. 
#     # slack-budget-alert comes from the package directory inside the function
#     service_uri             = "https://${azurerm_function_app.main.default_hostname}/api/slack-budget-alert"
#     use_common_alert_schema = false
#   }
# }

# resource "azurerm_monitor_action_group" "teams" {
#   count               = local.enable_teams ? 1 : 0
#   name                = "ag-teams-${var.func_identifier}-${var.env}-${var.location}"
#   resource_group_name = azurerm_resource_group.main.name
#   short_name          = "teams-ag"
#   tags                = var.budget_tags

#   webhook_receiver {
#     name = "callazurefuncapi"
#     # Using string interpolation to get full hostname of function. 
#     # teams-budget-alert comes from the package directory inside the function
#     service_uri             = "https://${azurerm_function_app.main.default_hostname}/api/teams-budget-alert"
#     use_common_alert_schema = false
#   }
# }
