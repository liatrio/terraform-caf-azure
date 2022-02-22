output "private_dns_zone_ids" {
  value = {
    for k, zone in azurerm_private_dns_zone.private_dns_zone : k => zone.id
  }
}
