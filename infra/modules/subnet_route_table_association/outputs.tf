output "route_table_associations" {
  value = { for k, v in azurerm_subnet_route_table_association.by_map : k => v.id }
}