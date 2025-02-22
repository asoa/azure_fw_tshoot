resource "azurerm_virtual_network_peering" "by_map" {
  for_each                  = var.virtual_network_peers
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
}