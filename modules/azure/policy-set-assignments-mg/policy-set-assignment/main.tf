terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

data "azurerm_management_group" "current" {
  name = var.target_management_group_id
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
  management_group_id  = data.azurerm_management_group.current.id
}
