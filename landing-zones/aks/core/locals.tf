locals {
  log_analytics_workspace_id = var.log_analytics_workspace_id == "" ? data.azurerm_log_analytics_workspace.management.id : var.log_analytics_workspace_id
}
