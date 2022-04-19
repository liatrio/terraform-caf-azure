resource "azurerm_resource_group" "caf_management" {
  provider = azurerm.management
  name     = "rg-${var.prefix}-management"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  provider = azurerm.management

  name                = "log-${var.prefix}-management"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "free"
  retention_in_days   = 30
}
