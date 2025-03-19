output "ip_ids" {
  value = { for k, v in azurerm_public_ip.by_map : k => v.id }
}

output "ip_addresses" {
  value = { for k, v in azurerm_public_ip.by_map : k => v.ip_address }
}