data "azurerm_policy_set_definition" "deny_paas_public_network" {
  name = "Deny-PublicPaaSEndpoints"
}

resource "azurerm_subscription_policy_assignment" "management" {
  name                 = "management-sub-deny-paas-public-network"
  policy_definition_id = data.azurerm_policy_set_definition.deny_paas_public_network.id
  subscription_id      = azurerm_subscription.management.id
}

resource "azurerm_subscription_policy_assignment" "connectivity" {
  name                 = "connectivity-subscription-deny-paas-public-network"
  policy_definition_id = data.azurerm_policy_set_definition.deny_paas_public_network.id
  subscription_id      = azurerm_subscription.connectivity.id
}

resource "azurerm_subscription_policy_assignment" "identity" {
  name                 = "identity-subscription-deny-paas-public-network"
  policy_definition_id = data.azurerm_policy_set_definition.deny_paas_public_network.id
  subscription_id      = azurerm_subscription.identity.id
}
