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

resource "azurerm_subscription" "shared_services" {
  for_each          = var.shared_services
  subscription_name = "${var.group_prefix}-${each.key}"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id

  tags = {}
}
