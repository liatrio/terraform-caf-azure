# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/main.tf

module "billing_alert_functions" {
  providers = {
    azurerm = azurerm.management
  }
  source = "../../modules/azure/billing-alert-functions"

  to_provision       = true # feature flag
  func_identifier    = var.func_identifier
  budget_time_start  = var.budget_time_start
  slack_webhook_url  = var.slack_webhook_url
  teams_webhook_url  = var.teams_webhook_url
  subscriptions      = var.subscriptions
  budget_threshold   = var.budget_threshold
  budget_operator    = var.budget_operator
  budget_time_grains = var.budget_time_grains
  budget_amounts     = var.budget_amounts
}
