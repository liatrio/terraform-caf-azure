data "azurerm_log_analytics_workspace" "management" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-management"
  resource_group_name = "rg-${var.prefix}-management"
}

resource "azurerm_security_center_workspace" "defender" {
  count        = var.enable_ms_defender == true ? 1 : 0
  scope        = data.azurerm_subscription.current.id
  workspace_id = data.azurerm_log_analytics_workspace.management.id
}
