resource "azurerm_virtual_network_gateway" "by_map" {
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
    public_ip_address_id          = each.value.ip_configuration.public_ip_address_id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    subnet_id                     = each.value.ip_configuration.subnet_id
  }
  vpn_client_configuration {
    address_space = each.value.vpn_client_configuration.address_space
    root_certificate {
      name             = each.value.vpn_client_configuration.root_certificate.name
      public_cert_data = each.value.vpn_client_configuration.root_certificate.public_cert_data
    }
  }
}

resource "azurerm_virtual_network_gateway_connection" "by_map" {
  for_each                        = var.virtual_network_gateway_connections
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  type                            = each.value.type
  virtual_network_gateway_id      = each.value.virtual_network_gateway_id
  peer_virtual_network_gateway_id = each.value.peer_virtual_network_gateway_id
  shared_key                      = each.value.shared_key
}


