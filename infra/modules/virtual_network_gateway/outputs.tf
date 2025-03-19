output "virtual_network_gateways" {
  value = { for k, v in azurerm_virtual_network_gateway.by_map : k => v.id }
}