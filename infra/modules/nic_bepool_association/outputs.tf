output "nic_bepool_associations" {
  value = { for k, v in azurerm_network_interface_backend_address_pool_association.by_map : k => v.id }
}