include {
  path = find_in_parent_folders()
}

dependency "subscription" {
  config_path = "../subscription"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

# List all the required variables along with their desired value
inputs = {
  location                              = local.common_vars.location
  prefix                                = local.common_vars.prefix
  name                                  = "aks-lz-dev"
  vnet_address_range                    = "0.0.0.0/16"
  node_count_min                        = 2
  vm_size                               = "standard_ds2"
  kubernetes_version                    = "1.21.9"
  connectivity_resource_group_name      = "caf-connectivity"
  connectivity_k8_private_dns_zone_name = "privatelink.centralus.azmk8s.io"
  environment                           = "stg"
  shared_services_keyvault              = "caf-staging"
  shared_services_resource_group        = "caf-shared-services-staging-rg"
  connectivity_dns_servers              = local.common_vars.connectivity_dns_servers
}

# Use the latest stable release, see https://github.com/liatrio/terraform-caf-azure/releases
terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//landing-zones/aks/core?ref=v0.19.1"
}

# Generate the provider.tf files
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
      alias           = "shared_services" 
      tenant_id       = "${local.common_vars.tenant_id}"
      subscription_id = "${local.common_vars.shared_services_staging_subscription_id}"
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
