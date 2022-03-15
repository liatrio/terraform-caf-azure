terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

module "policy_assignment" {
  source = "./policy-set-assignment"

  count = length(var.policy_sets)
  target_management_group_id = var.target_management_group_id
  policy_set_id              = var.policy_sets[count.index].policy_set_id
  policy_parameters          = lookup(var.policy_sets[count.index], "parameters", null)
}
