include {
  path = find_in_parent_folders()
}

dependency "subscriptions" {
  config_path = "../subscriptions"
}

dependency "active_directory" {
  config_path = "../active-directory"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

inputs = {
  vpn_service_principal_application_id = dependency.active_directory.outputs.vpn_service_principal_application_id
  location                             = local.common_vars.location
  virtual_hub_address_cidr             = "0.0.0.0/0"
  vpn_client_pool_address_cidr         = "0.0.0.0/0"
  connectivity_apps_address_cidr       = "0.0.0.0/0"
  tenant_id                            = local.common_vars.tenant_id
  prefix                               = local.common_vars.prefix
  root_dns_zone                        = "your.dns.zone"
  root_dns_tags = {
    features = "caf_root_dns"
  }
  landing_zone_mg = {
    corp : { display_name = "Corp", policy_ids = [
      { policy_set_id : "/providers/Microsoft.Authorization/policySetDefinitions/42b8ef37-b724-4e24-bbc8-7a7708edfe00" }
    ] },
    online : { display_name = "Online", policy_ids = [] }
  }
}

terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//foundation/core?ref=v0.11.0"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "azurerm" {
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${local.common_vars.pay-as-you-go_subscription_id}"
      features {}
    }
    provider "azurerm" {
      alias           = "identity"
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${dependency.subscriptions.outputs.identity_subscription_id}"
      features {}
    }
    provider "azurerm" {
      alias           = "management"
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${dependency.subscriptions.outputs.management_subscription_id}"
      features {}
    }
    provider "azurerm" {
      alias           = "connectivity"
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${dependency.subscriptions.outputs.connectivity_subscription_id}"
      features {}
    }
    EOF
}
