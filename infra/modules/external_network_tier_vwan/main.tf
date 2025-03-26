resource "azurerm_virtual_wan" "vwan" {
  for_each            = var.virtual_wans
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  type                = each.value.type
}

resource "azurerm_virtual_hub" "hub" {
  for_each                               = var.virtual_hubs
  name                                   = each.value.name
  resource_group_name                    = each.value.resource_group_name
  location                               = each.value.location
  virtual_wan_id                         = azurerm_virtual_wan.vwan[each.key].id
  address_prefix                         = each.value.address_prefix
  virtual_router_auto_scale_min_capacity = each.value.virtual_router_auto_scale_min_capacity
  hub_routing_preference                 = each.value.hub_routing_preference
}

resource "azurerm_vpn_gateway" "vpn_gw" {
  for_each            = var.vpn_gateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  virtual_hub_id      = azurerm_virtual_hub.hub[each.key].id
  scale_unit          = each.value.scale_unit
  routing_preference  = each.value.routing_preference
  bgp_settings {
    asn         = each.value.bgp_settings.asn
    peer_weight = each.value.bgp_settings.peer_weight
  }
}

resource "azurerm_virtual_hub_route_table" "hub_rt" {
  for_each       = var.hub_route_tables
  name           = "${each.value.name}-rt"
  virtual_hub_id = var.virtual_hubs[each.key].name
  route {
    name              = each.value.route.name
    destinations_type = each.value.route.destinations_type
    destinations      = each.value.route.destinations
    next_hop_type     = each.value.route.next_hop_type
    next_hop          = each.value.route.next_hop
  }
}

resource "azurerm_virtual_hub_connection" "hub_vnet" {
  for_each                  = var.virtual_hub_connections
  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.hub[each.value.virtual_hub_id].id
  remote_virtual_network_id = var.vnet_ids[each.value.remote_virtual_network_id]
  # routing {
  #   associated_route_table_id = each.value.routing.associated_route_table_id
  # }
}


