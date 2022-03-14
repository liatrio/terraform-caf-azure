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

  for_each                   = toset(var.policy_set_ids)
  target_management_group_id = var.target_management_group_id
  policy_set_id              = each.value
}
