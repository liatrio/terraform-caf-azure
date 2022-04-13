include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

inputs = {
  name                  = "${local.common_vars.prefix}-shared-services-staging"
  tenant_id             = local.common_vars.tenant_id
  billing_account_name  = local.common_vars.billing_account_name
  billing_profile_name  = local.common_vars.billing_profile_name
  invoice_section_name  = local.common_vars.invoice_section_name
  management_group_name = "${local.common_vars.prefix}-shared-svc"
}

terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//subscriptions/landing-zone?ref=v0.8.0"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "azurerm" {
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${local.common_vars.pay-as-you-go_subscription_id}"
      features {}
    }
    EOF
}
