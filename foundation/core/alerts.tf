# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/main.tf

module "billing_alert_functions" {
  providers = {
    azurerm = azurerm.management
  }
  source = "../../modules/azure/billing-alert-functions"

  count             = var.enable_budget_alerts ? 1 : 0
  func_identifier   = var.func_identifier
  slack_webhook_url = var.slack_webhook_url
  teams_webhook_url = var.teams_webhook_url
  location          = var.location
  env               = var.env
  budgets           = var.budgets
  budget_tags       = var.budget_tags
  sas_time_start    = var.sas_time_start
  sas_time_end      = var.sas_time_end
}
