
data "azuread_client_config" "current" {}

resource "azuread_application" "shared_services_app" {
  display_name = "shared_services_app"
  owners       = [data.azuread_client_config.current.object_id]
}
resource "azuread_service_principal" "azure_vpn" {
  application_id = azuread_application.shared_services_app.id

  feature_tags {
    custom_single_sign_on = false
    enterprise            = true
    gallery               = false
    hide                  = false
  }
}
