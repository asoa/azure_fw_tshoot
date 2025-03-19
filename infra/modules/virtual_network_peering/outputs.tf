output "network_peers" {
  value = { for k, v in azurerm_virtual_network_peering.by_map : k => v.id }
}