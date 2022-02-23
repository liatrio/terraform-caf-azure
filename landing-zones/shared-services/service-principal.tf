data "azuread_client_config" "current" {}

data "azurerm_subscription" "current" {
  subscription_id = var.sub_id
}

resource "azuread_application" "shared_services_app" {
  display_name = "shared_services_app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "shared_services_sp" {
  application_id = azuread_application.shared_services_app.application_id

  feature_tags {
    custom_single_sign_on = false
    enterprise            = true
    gallery               = false
    hide                  = false
  }
}

data "azuread_service_principal" "shared_services_sp" {
  object_id = azuread_service_principal.shared_services_sp.object_id
}

resource "azurerm_role_assignment" "subscription_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_service_principal.shared_services_sp.object_id
}
