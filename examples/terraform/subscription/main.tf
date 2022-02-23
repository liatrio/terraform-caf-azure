provider "azurerm" {
  features {}
}

module "foundation_subscriptions" {
  source = "git@github.com:liatrio/terraform-caf-azure//bootstrap/subscriptions?ref=main"

  group_prefix = "example"
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}


