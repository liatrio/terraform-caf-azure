terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

resource "random_id" "policy_association_name" {
  keepers = {
    id = var.policy_set_id
  }

  byte_length = 12
}

resource "azurerm_management_group_policy_assignment" "policy_set_assignment" {
  name                 = random_id.policy_association_name.id
  policy_definition_id = var.policy_set_id
  management_group_id  = var.target_management_group_id

  parameters = var.policy_parameters
}
