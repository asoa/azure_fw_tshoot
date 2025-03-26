resource "azurerm_virtual_network_gateway" "vnet_gw" {
  for_each            = var.virtual_network_gateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  type                = each.value.type
  vpn_type            = each.value.vpn_type
  active_active       = each.value.active_active
  enable_bgp          = each.value.enable_bgp
  sku                 = each.value.sku
  ip_configuration {
    name                          = each.value.ip_configuration.name
    public_ip_address_id          = var.public_ips[each.key]
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    subnet_id                     = var.subnet_ids[each.value.ip_configuration.subnet_name]
  }
  dynamic "vpn_client_configuration" {
    # this block is created if the condition is true (e.g. if the vpn_type is "Vpn"); 
    # otherwise, the for_each is [] and the block is not created
    for_each = each.value.vpn_type == "Vpn" ? [each.value.vpn_client_configuration] : []
    content {
      address_space = each.value.vpn_client_configuration.address_space
      root_certificate {
        name             = each.value.vpn_client_configuration.root_certificate.name
        public_cert_data = var.root_public_certificate
      }
    }
  }
}

resource "azurerm_virtual_network_gateway_connection" "by_map" {
  for_each                        = var.virtual_network_gateway_connections
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  type                            = each.value.type
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vnet_gw[split("_", each.key)[0]].id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet_gw[split("_", each.key)[1]].id
  shared_key                      = each.value.shared_key
}

resource "azurerm_express_route_circuit" "er_circuit" {
  for_each              = var.express_route_circuits
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  service_provider_name = each.value.service_provider_name
  peering_location      = each.value.peering_location
  bandwidth_in_mbps     = each.value.bandwidth_in_mbps
  sku {
    tier   = each.value.sku.tier
    family = each.value.sku.family
  }
}





