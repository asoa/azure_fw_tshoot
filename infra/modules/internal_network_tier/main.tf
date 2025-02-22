# TODO:
# route table, route table association

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.security_groups
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  # security_rule       = each.value.security_rule
  dynamic "security_rule" {
    for_each = { for v in each.value.security_rules : v.name => v }
    content {
      name                                       = security_rule.value.name
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access
      protocol                                   = security_rule.value.protocol
      source_port_range                          = security_rule.value.source_port_range
      destination_port_range                     = security_rule.value.destination_port_range
      source_address_prefix                      = security_rule.value.source_address_prefix
      destination_address_prefix                 = security_rule.value.destination_address_prefix
      description                                = security_rule.value.description
      destination_address_prefixes               = security_rule.value.destination_address_prefixes
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids
      destination_port_ranges                    = security_rule.value.destination_port_ranges
      source_address_prefixes                    = security_rule.value.source_address_prefixes
      source_application_security_group_ids      = security_rule.value.source_application_security_group_ids
      source_port_ranges                         = security_rule.value.source_port_ranges
    }
  }
}

resource "azurerm_virtual_network" "nw" {
  for_each            = var.networks
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  dynamic "subnet" {
    # create a unique k:v mapping for iteration
    for_each = { for v in each.value.subnet : v.name => v }
    content {
      name              = subnet.value.name
      address_prefixes  = subnet.value.address_prefixes
      security_group    = subnet.value.security_group != null ? azurerm_network_security_group.nsg[subnet.value.security_group].id : ""
      service_endpoints = subnet.value.service_endpoints
    }
  }
  dynamic "ddos_protection_plan" {
    for_each = each.value.enable_ddos_protection ? [each.value.ddos_protection_plan] : []
    content {
      id     = azurerm_network_ddos_protection_plan.ddos[each.key].id
      enable = each.value.ddos_protection_plan.enable
    }
  }
  depends_on = [azurerm_network_ddos_protection_plan.ddos]
}

resource "azurerm_virtual_network_peering" "vent_peer" {
  for_each                  = var.virtual_network_peers
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.nw[each.value.remote_virtual_network_id].id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
}

resource "azurerm_private_dns_zone" "dns" {
  for_each            = var.private_dns_zones
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vn_link" {
  for_each              = var.private_dns_zone_link
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns[each.key].name
  virtual_network_id    = azurerm_virtual_network.nw[each.key].id
  registration_enabled  = each.value.registration_enabled
}

resource "azurerm_network_ddos_protection_plan" "ddos" {
  for_each            = var.ddos_protection_plans
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}