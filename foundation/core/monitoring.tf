resource "azurerm_resource_group" "caf_management" {
  provider = azurerm.management
  name     = "rg-${var.prefix}-management-${var.environment}-${var.location}"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-management-${var.environment}-${var.location}"
  location            = azurerm_resource_group.caf_management.location
  resource_group_name = azurerm_resource_group.caf_management.name
  sku                 = var.log_analytics_ws_sku
  retention_in_days   = 30
}

resource "azurerm_security_center_workspace" "defender" {
  count        = var.enable_ms_defender == true ? 1 : 0
  scope        = data.azurerm_subscription.current.id
  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
