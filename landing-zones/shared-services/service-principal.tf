
data "azuread_client_config" "current" {}

resource "azuread_application" "shared_services_app" {
  display_name = "shared_services_app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "shared_services_sp" {
  application_id = azuread_application.shared_services_app.id

  feature_tags {
    custom_single_sign_on = false
    enterprise            = true
    gallery               = false
    hide                  = false
  }
}

resource "azurerm_role_assignment" "example" {
  scope                = var.sub_id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}
