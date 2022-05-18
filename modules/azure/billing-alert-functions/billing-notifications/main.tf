terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
}

resource "azurerm_consumption_budget_subscription" "example" {
  for_each        = var.budgets
  name            = "bdg-${var.func_identifier}-core-${var.location}"
  subscription_id = "/subscriptions/${each.value["subscription_id"]}"
  amount          = each.value["budget_amount"]
  time_grain      = each.value["budget_time_grain"]

  time_period {
    start_date = each.value["budget_time_start"]
  }

  notification {
    enabled   = true
    threshold = each.value["budget_threshold"]
    operator  = each.value["budget_operator"]

    contact_groups = var.contact_groups
  }
}
