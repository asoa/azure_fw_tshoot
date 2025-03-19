resource "azurerm_route_table" "by_map" {
  for_each            = var.route_tables
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  route = [
    for k, v in each.value.route : {
      name                   = v.name
      address_prefix         = v.address_prefix
      next_hop_type          = v.next_hop_type
      next_hop_in_ip_address = v.next_hop_in_ip_address
    }
  ]
}