data "azurerm_management_group" "platform" {
  name = "${var.group_prefix}-platform"
}

resource "azurerm_management_group" "identity" {
  name                       = "${var.group_prefix}-identity"
  display_name               = "Identity"
  parent_management_group_id = data.azurerm_management_group.platform.id
  subscription_ids = [
    var.identity_id
  ]
}
