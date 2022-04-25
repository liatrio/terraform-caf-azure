terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
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
  amount          = var.amount
  time_grain      = var.time_grain

  time_period {
    start_date = "2022-06-01T00:00:00Z" 
    # end_date   = "2022-07-01T00:00:00Z" # Defaults to 10 years when no end_date
  }

  notification {
    enabled   = true
    threshold = var.threshold
    operator  = var.operator

    contact_groups = [
      azurerm_monitor_action_group.example[count.index].id,
    ]
  }
}