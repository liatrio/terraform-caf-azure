output "disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.encryption_set[0].id
}
