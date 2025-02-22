resource "azurerm_subnet_route_table_association" "by_map" {
  for_each       = var.subnet_route_table_associations
  subnet_id      = each.value.subnet_id      # override in main
  route_table_id = each.value.route_table_id # override in main with output values from route_table module
}