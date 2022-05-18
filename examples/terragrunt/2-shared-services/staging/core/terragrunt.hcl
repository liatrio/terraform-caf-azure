include {
  path = find_in_parent_folders()
}

dependency "subscription" {
  config_path = "../subscription"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

inputs = {
  location                         = local.common_vars.location
  prefix                           = local.common_vars.prefix
  vnet_address_range               = "0.0.0.0/0"
  node_count_min                   = 2
  vm_size                          = "standard_ds2"
  pool_name                        = "default"
  env                              = "staging"
  kubernetes_version               = "1.21.9"
  parent_dns_zone_name             = "your.dns.zone"
  connectivity_resource_group_name = "caf-connectivity"
  public_dns_zone_name             = "shared-svc-staging.your.dns.zone"
  connectivity_dns_servers         = local.common_vars.connectivity_dns_servers
}

terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//foundation/shared-services/core?ref=v0.16.0"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "azurerm" {
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${dependency.subscription.outputs.subscription_id}"
      features {}
    }
    provider "azurerm" {
      alias           = "connectivity"
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${local.common_vars.connectivity_subscription_id}"
      features {}
    }
    provider "azurerm" {
      alias           = "management"
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${dependency.subscriptions.outputs.management_subscription_id}"
      features {}
    }
    EOF
}
