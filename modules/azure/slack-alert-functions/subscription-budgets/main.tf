terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_monitor_action_group" "slack" {
  count               = var.enable_slack == true ? 1 : 0
  name                = "action-group-${var.slack_func_identifier}"
  resource_group_name = var.resource_group_name
  short_name          = "slack-ag"

  webhook_receiver {
    name = "callazurefuncapi"
    # Using string interpolation to get full hostname of function. 
    # slack-budget-alert comes from the package directory inside the function
    service_uri             = "https://${var.default_hostname}/api/slack-budget-alert"
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_action_group" "teams" {
  count               = var.enable_teams == true ? 1 : 0
  name                = "action-group-${var.slack_func_identifier}"
  resource_group_name = var.resource_group_name
  short_name          = "slack-ag"

  webhook_receiver {
    name = "callazurefuncapi"
    # Using string interpolation to get full hostname of function. 
    # teams-budget-alert comes from the package directory inside the function
    service_uri             = "https://${var.default_hostname}/api/teams-budget-alert"
    use_common_alert_schema = false
  }
}

locals {
  contact_groups = flatten([
    var.enable_slack == true ? [azurerm_monitor_action_group.slack[0].id] : [],
    var.enable_teams == true ? [azurerm_monitor_action_group.teams[0].id] : []
  ])
}

resource "azurerm_consumption_budget_subscription" "example" {
  for_each        = var.subscriptions
  name            = "budget-${var.slack_func_identifier}"
  subscription_id = each.value
  amount          = var.budget_amounts[each.key]
  time_grain      = var.budget_time_grains[each.key]

  time_period {
    start_date = "2022-06-01T00:00:00Z"
    # end_date   = "2022-07-01T00:00:00Z" # Defaults to 10 years when no end_date
  }

  notification {
    enabled   = true
    threshold = var.budget_threshold[each.key]
    operator  = var.budget_operator[each.key]

    contact_groups = local.contact_groups
  }
}
