terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.96"
    }
  }
}
data "azurerm_management_group" "platform" {
  name = "${var.group_prefix}-platform"
}

resource "azurerm_management_group" "management" {
  name                       = "${var.group_prefix}-management"
  display_name               = "Management"
  parent_management_group_id = data.azurerm_management_group.platform.id
  subscription_ids = [
    var.management_id
  ]
}
