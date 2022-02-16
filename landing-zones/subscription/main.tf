terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

data "azurerm_billing_mca_account_scope" "billing" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

resource "azurerm_subscription" "landing_zone" {
  subscription_name = var.name
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}

data "azurerm_management_group" "landing_zone_mg" {
  name = "var.management_group_display_name"
}

resource "azurerm_management_group_subscription_association" "landing_zone_mg_association" {
  subscription_id     = azurerm_subscription.landing_zone.id
  management_group_id = data.azurerm_management_group.landing_zone_mg.id
}
