output "route_tables" {
  value = { for rt in azurerm_route_table.by_map : rt.name => rt.id }
}

output "route_tables_subnets" {
  value = { for rt in azurerm_route_table.by_map : rt.name => rt.subnets }
}