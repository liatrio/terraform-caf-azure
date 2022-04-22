# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/main.tf

module "slack_alert_functions" {
  providers = { 
    azurerm            = azurerm.management
  }
  source = "../../modules/azure/slack-alert-functions"

  slack_func_identifier   = var.slack_func_identifier
  slack_webhook_url       = var.slack_webhook_url
}

# module.alert_functions.function_app_name
# module.alert_functions.function_app_default_hostname
