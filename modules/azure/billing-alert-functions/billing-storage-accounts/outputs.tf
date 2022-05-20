output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.func.name
}

output "storage_account_primary_key" {
  value = azurerm_storage_account.func.primary_access_key
}

output "storage_container_name" {
  value = azurerm_storage_container.deployments.name
}

output "storage_blob_name" {
  value = azurerm_storage_blob.storage_blob.name
}

output "storage_blob_sas" {
  value = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
}
