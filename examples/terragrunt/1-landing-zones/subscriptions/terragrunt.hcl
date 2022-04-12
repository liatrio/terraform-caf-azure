include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

# List all the required variables along with their desired value
inputs = {
  name                  = "aks-lz-dev"
  tenant_id             = local.common_vars.tenant_id
  billing_account_name  = local.common_vars.billing_account_name
  billing_profile_name  = local.common_vars.billing_profile_name
  invoice_section_name  = local.common_vars.invoice_section_name
  management_group_name = "${local.common_vars.prefix}-name_of_your_management_group"
}

# Use the latest stable release, see https://github.com/liatrio/terraform-caf-azure/releases
terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//subscriptions/landing-zone?ref=v0.19.1"
}

# Generate the provider.tf file
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
