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

resource "azurerm_subscription" "shared_services_subscription_id" {
  subscription_name = "${var.prefix}-${var.name}"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}
