data "azurerm_log_analytics_workspace" "management" {
  provider            = azurerm.management
  name                = "log-${var.prefix}-management-${var.environment}-${var.location}"
  resource_group_name = "rg-${var.prefix}-management-${var.environment}-${var.location}"
}

resource "azurerm_security_center_workspace" "defender" {
  count        = var.enable_ms_defender == true ? 1 : 0
  scope        = data.azurerm_subscription.current.id
  workspace_id = data.azurerm_log_analytics_workspace.management.id
}

resource "azurerm_security_center_subscription_pricing" "enabled_resource" {
  for_each = {
    for resource_name, resource in var.ms_defender_enabled_resources : resource_name => resource
    if resource
  }
  tier          = "Standard"
  resource_type = each.key
}
