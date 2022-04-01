provider "azurerm" {
  features {}
}

module "foundation_subscriptions" {
  source = "git@github.com:liatrio/terraform-caf-azure//subscriptions/foundation?ref=main"

  group_prefix         = "example"
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

module "shared_services_subscription" {
  source = "git@github.com:liatrio/terraform-caf-azure//subscriptions/landing-zone?ref=main"

  management_group_name = "example-shared-svc"
  name                  = "example-shared-services"
  billing_account_name  = var.billing_account_name
  billing_profile_name  = var.billing_profile_name
  invoice_section_name  = var.invoice_section_name
}

