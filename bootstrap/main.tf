resource "azurerm_resource_group" "terraformstate" {
  name     = "terraform"
  location = var.location
}

resource "azurerm_storage_account" "terraformstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.terraformstate.name
  location                 = azurerm_resource_group.terraformstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {}
}

resource "azurerm_storage_container" "terraformstate" {
  name                  = "terraform-caf-azure-liatrio"
  storage_account_name  = azurerm_storage_account.terraformstate.name
  container_access_type = "private"
}
