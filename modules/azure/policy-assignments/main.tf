terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

module "policy_assignment" {
  source = "./policy-assignment"

  for_each            = toset(var.policy_ids)
  management_group_id = var.management_group_id
  policy_id           = each.value
}


