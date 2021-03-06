data "azurerm_client_config" "default" {}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

data "azurerm_subscription" "management" {
  subscription_id = data.azurerm_client_config.management.subscription_id
}

data "azurerm_client_config" "identity" {
  provider = azurerm.identity
}

data "azurerm_subscription" "identity" {
  subscription_id = data.azurerm_client_config.identity.subscription_id
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_subscription" "connectivity" {
  subscription_id = data.azurerm_client_config.connectivity.subscription_id
}

data "azurerm_subscription" "current" {
}
