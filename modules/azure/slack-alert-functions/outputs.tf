# code adapted from:
# https://www.maxivanov.io/deploy-azure-functions-with-terraform/

output "function_app_name" {
  value = azurerm_function_app.main.name
  description = "Deployed function app name"
}

output "function_app_default_hostname" {
  value = azurerm_function_app.main.default_hostname
  description = "Deployed function app hostname"
}
