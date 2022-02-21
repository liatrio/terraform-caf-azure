terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}

data "azurerm_management_group" "current" {
  name = var.management_group_id
}

data "azurerm_policy_set_definition" "current" {
  name = var.policy_id
}

resource "random_id" "policy_association_name" {
  keepers = {
    id = var.policy_id
  }

  byte_length = 12
}

resource "azurerm_management_group_policy_assignment" "landing_zone_policies" {
  name                 = random_id.policy_association_name.id
  policy_definition_id = data.azurerm_policy_set_definition.current.id
  management_group_id  = data.azurerm_management_group.current.id
}
