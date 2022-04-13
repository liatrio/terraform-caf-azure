skip = true

locals {
  common_vars = yamldecode(file("common-vars.yaml"))
}

remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    resource_group_name  = "resource_group_name"
    storage_account_name = "storage_account_name"
    container_name       = "container_name"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    tenant_id            = local.common_vars.tenant_id
    subscription_id      = local.common_vars.terraform_state_subscription_id
  }
}

terraform_version_constraint  = ">= 1.0"
terragrunt_version_constraint = ">=0.31"