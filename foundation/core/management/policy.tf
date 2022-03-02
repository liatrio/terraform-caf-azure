data "azurerm_policy_set_definition" "deny_paas_public_network" {
  name = "Deny-PublicPaaSEndpoints"
}

resource "azurerm_management_group_policy_assignment" "foundation_deny_pass_public_network" {
  name                 = "foundation-deny-pass"
  policy_definition_id = data.azurerm_policy_set_definition.deny_paas_public_network.id
  management_group_id  = azurerm_management_group.foundation.id
}
