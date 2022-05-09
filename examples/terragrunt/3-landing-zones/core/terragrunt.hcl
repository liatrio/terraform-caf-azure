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
  external_app                          = true
  dns_zone_name                         = "your-sub.myzone.com"
  parent_dns_zone_name                  = "myzone.com"

  # Security inputs
  enable_aks_policy_addon = true
  enable_ms_defender      = false
  ms_defender_enabled_resources = {
    "Containers" = false
  }
  aks_enable_disk_encryption = true
  vault_key_to_create = {
    name                     = "mykey"
    used_for_disk_encryption = true
    # Key type defaulted to EC - select elliptical curve strength below
    curve = "P-384"
  }
  certificate_permission = ["Get", ]
  key_permission         = ["Get", ]
  secret_permission      = ["Get", ]
  storage_permission     = ["Get", ]
  application_id         = "yourappidforkeyvaultaccesspolicy"
}

# Use the latest stable release, see https://github.com/liatrio/terraform-caf-azure/releases
terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//landing-zones/aks/core?ref=v0.35.0"
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
