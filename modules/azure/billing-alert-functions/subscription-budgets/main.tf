terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96.0"
    }
  }
}

resource "azurerm_monitor_action_group" "slack" {
  count               = var.enable_slack ? 1 : 0
  name                = "ag-slack_${var.func_identifier}-${var.env}-${var.location}"
  resource_group_name = var.resource_group_name
  short_name          = "slack-ag"
  tags                = var.budget_tags

  webhook_receiver {
    name = "callazurefuncapi"
    # Using string interpolation to get full hostname of function. 
    # slack-budget-alert comes from the package directory inside the function
    service_uri             = "https://${var.default_hostname}/api/slack-budget-alert"
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_action_group" "teams" {
  count               = var.enable_teams ? 1 : 0
  name                = "ag-teams_${var.func_identifier}-${var.env}-${var.location}"
  resource_group_name = var.resource_group_name
  short_name          = "teams-ag"
  tags                = var.budget_tags

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
    var.enable_slack ? [azurerm_monitor_action_group.slack[0].id] : [],
    var.enable_teams ? [azurerm_monitor_action_group.teams[0].id] : []
  ])
}

resource "azurerm_consumption_budget_subscription" "example" {
  for_each        = var.subscriptions
  name            = "bdg-${var.func_identifier}-${var.env}-${var.location}"
  subscription_id = each.value
  amount          = var.budget_amounts[each.key]
  time_grain      = var.budget_time_grains[each.key]

  time_period {
    start_date = var.budget_time_start
  }

  notification {
    enabled   = true
    threshold = var.budget_threshold[each.key]
    operator  = var.budget_operator[each.key]

    contact_groups = local.contact_groups
  }
}
