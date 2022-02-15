resource "azurerm_subscription" "management" {
  subscription_name = "${var.group_prefix}-management"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}

resource "azurerm_subscription" "connectivity" {
  subscription_name = "${var.group_prefix}-connectivity"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}

resource "azurerm_subscription" "identity" {
  subscription_name = "${var.group_prefix}-identity"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}