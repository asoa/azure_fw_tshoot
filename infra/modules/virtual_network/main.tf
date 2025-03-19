resource "azurerm_virtual_network" "by_map" {
  for_each            = var.networks
  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_security_group" "by_map" {
  for_each            = var.security_groups
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  security_rule       = each.value.security_rule
}

resource "azurerm_subnet" "by_map" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  depends_on           = [azurerm_virtual_network.by_map]
}

resource "azurerm_subnet_network_security_group_association" "by_map" {
  for_each                  = var.nsg_subnet_association
  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.network_security_group_id
  depends_on                = [azurerm_network_security_group.by_map, azurerm_subnet.by_map]
}

resource "azurerm_virtual_network_peering" "by_map" {
  for_each                  = var.virtual_network_peers
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
}

resource "azurerm_private_dns_zone" "by_map" {
  for_each            = var.private_dns_zones
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  depends_on          = [azurerm_virtual_network.by_map]
}

resource "azurerm_private_dns_zone_virtual_network_link" "by_map" {
  for_each              = var.private_dns_zone_vnet_link
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = each.value.private_dns_zone_name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled
  depends_on            = [azurerm_private_dns_zone.by_map]
}

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

