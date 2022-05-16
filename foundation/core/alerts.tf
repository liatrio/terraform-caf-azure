# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/main.tf

module "billing_storage_accounts" {
  providers = {
    azurerm = azurerm.management
  }
  source = "../../modules/azure/billing-alert-functions/billing-storage-accounts"

  # If one or both of the webhook URLs is set, and the feature flag is turned on, then call this module
  count           = ((var.slack_webhook_url != "" || var.teams_webhook_url != "") && var.enable_budget_alerts) ? 1 : 0
  func_identifier = var.func_identifier
  location        = var.location
  env             = var.env
  budget_tags     = var.budget_tags
  sas_time_start  = var.sas_time_start
  sas_time_end    = var.sas_time_end
}

module "billing_function_apps" {
  providers = {
    azurerm = azurerm.management
  }
  source = "../../modules/azure/billing-alert-functions/billing-function-apps"

  # If one or both of the webhook URLs is set, and the feature flag is turned on, then call this module
  count             = ((var.slack_webhook_url != "" || var.teams_webhook_url != "") && var.enable_budget_alerts) ? 1 : 0
  func_identifier   = var.func_identifier
  slack_webhook_url = var.slack_webhook_url
  teams_webhook_url = var.teams_webhook_url
  location          = var.location
  env               = var.env
  budget_tags       = var.budget_tags

  # outputs needed from previous module
  resource_group_name         = module.billing_storage_accounts[0].resource_group_name
  storage_account_name        = module.billing_storage_accounts[0].storage_account_name
  storage_account_primary_key = module.billing_storage_accounts[0].storage_account_primary_key
  storage_container_name      = module.billing_storage_accounts[0].storage_container_name
  storage_blob_name           = module.billing_storage_accounts[0].storage_blob_name
  storage_blob_sas            = module.billing_storage_accounts[0].storage_blob_sas
}

locals {
  contact_groups = flatten([
    var.slack_webhook_url != "" ? [module.billing_function_apps[0].slack_action_group_id] : [],
    var.teams_webhook_url != "" ? [module.billing_function_apps[0].teams_action_group_id] : []
  ])
}

module "billing_notifications" {
  providers = {
    azurerm = azurerm.management
  }
  source = "../../modules/azure/billing-alert-functions/billing-notifications"

  count           = var.enable_budget_alerts ? 1 : 0
  budgets         = var.budgets
  contact_groups  = local.contact_groups
  func_identifier = var.func_identifier
  location        = var.location
  env             = var.env
}
