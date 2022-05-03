output "disk_encryption_set_id" {
  value = length(azurerm_disk_encryption_set.encryption_set) > 0 ? azurerm_disk_encryption_set.encryption_set[0].id : null
}
