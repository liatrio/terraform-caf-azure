data "azurerm_management_group" "platform" {
  name = "${var.group_prefix}-platform"
}

resource "azurerm_management_group" "connectivity" {
  name                       = "${var.group_prefix}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = data.azurerm_management_group.platform.id
  subscription_ids = [
    var.connectivity_id
  ]
}
