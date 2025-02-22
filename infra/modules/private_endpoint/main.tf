resource "azurerm_private_endpoint" "pe" {
  for_each            = var.private_endpoints
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = each.value.subnet_id

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = each.value.private_connection_resource_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = each.value.is_manual_connection
  }

  private_dns_zone_group {
    name                 = each.value.private_dns_zone_group_name
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

}

resource "azurerm_private_dns_zone" "pdz" {
  for_each            = var.private_dns_zones
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdzvnl" {
  for_each              = var.private_dns_zone_virtual_network_links
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdz[each.value.private_dns_zone_name].id
  virtual_network_id    = var.vnet_ids[each.value.virtual_network_id]
}