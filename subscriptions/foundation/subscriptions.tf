resource "azurerm_subscription" "management" {
  subscription_name = "${var.prefix}-management"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}

resource "azurerm_subscription" "connectivity" {
  subscription_name = "${var.prefix}-connectivity"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}

resource "azurerm_subscription" "identity" {
  subscription_name = "${var.prefix}-identity"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}
