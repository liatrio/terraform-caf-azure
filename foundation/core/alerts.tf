# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/main.tf

module "slack_alert_functions" {
  providers = {
    azurerm = azurerm.management
  }
  source = "../../modules/azure/slack-alert-functions"

  # to_provision          = false # feature flag
  slack_func_identifier = var.slack_func_identifier
  slack_webhook_url     = var.slack_webhook_url
  subscriptions         = var.subscriptions
  budget_threshold      = var.budget_threshold
  budget_operator       = var.budget_operator
  budget_time_frames    = var.budget_time_frames
  budget_amounts        = var.budget_amounts 
  // TODO: have it consume list of subscription ids, budget amounts, and time frames
}
