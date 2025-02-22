output "networks" {
  value = { for vn in azurerm_virtual_network.by_map : vn.name => vn.id }
}

output "subnets" {
  value = { for k, v in azurerm_subnet.by_map : k => v.id }
}

output "security_groups" {
  value = { for k, v in azurerm_network_security_group.by_map : k => v.id }
}