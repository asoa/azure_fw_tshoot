output "virtual_machines" {
  value = { for vm in azurerm_windows_virtual_machine_scale_set.by_map : vm.name => vm.id }
}

# output "network_interfaces" {
#   value = { for k, v in azurerm_network_interface.by_map : k => v.id }
# }

# output "private_ip_addresses" {
#   value = { for k, v in azurerm_network_interface.by_map : k => v.private_ip_address }
# }

output "vm_identities" {
  value = { for k, v in azurerm_windows_virtual_machine_scale_set.by_map : k => v.identity[0] }
}