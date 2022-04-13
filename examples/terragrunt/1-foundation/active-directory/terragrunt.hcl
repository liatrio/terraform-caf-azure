include {
  path = find_in_parent_folders()
}
terraform {
  source = "git@github.com:liatrio/terraform-caf-azure//foundation/active-directory?ref=v0.11.0"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

inputs = {
  tenant_id = local.common_vars.tenant_id
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "azuread" {
      tenant_id = "${local.common_vars.tenant_id}"
    }
    EOF
}
