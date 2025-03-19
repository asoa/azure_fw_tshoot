resource "random_string" "rs" {
  length  = 4
  special = false
}

resource "azurerm_firewall_policy" "fw_policy" {
  for_each            = var.firewall_policies
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_rcg" {
  for_each           = var.firewall_policy_rule_collection_groups
  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.fw_policy[each.value.firewall_policy].id
  priority           = each.value.priority
  dynamic "application_rule_collection" {
    for_each = strcontains(each.value.name, "app") ? each.value.application_rule_collections : []
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action
      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name = rule.value.name
          protocols {
            type = rule.value.protocols.type
            port = rule.value.protocols.port
          }
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns
        }
      }
    }
  }
  dynamic "network_rule_collection" {
    for_each = strcontains(each.value.name, "network") ? each.value.network_rule_collections : []
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action
      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = [var.backend_ip_addresses[0]]
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }
  dynamic "nat_rule_collection" {
    for_each = strcontains(each.value.name, "nat") ? each.value.nat_rule_collections : []
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action
      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          translated_address  = var.backend_ip_addresses[0]
          translated_port     = rule.value.translated_port
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = var.ip_addresses[rule.value.destination_address]
          destination_ports   = rule.value.destination_ports
        }
      }
    }
  }
}

resource "azurerm_firewall" "fw" {
  for_each            = var.firewalls
  name                = "${each.value.name}-${random_string.rs.result}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  dynamic "ip_configuration" {
    # if sku_name is AZFW_VNet, then subnet_id is required
    # ip_configuration is not required for AZFW_Hub
    for_each = each.value.sku_name == "AZFW_VNet" ? [each.value.ip_configuration] : []
    content {
      name                 = ip_configuration.value.name
      subnet_id            = var.subnet_ids["hub"][ip_configuration.value.subnet_id]
      public_ip_address_id = var.ip_ids[each.value.ip_configuration.public_ip_address_id]
    }
  }
  dynamic "virtual_hub" {
    # if sku_name is AZFW_Hub, then virtual_hub is required
    for_each = each.value.sku_name == "AZFW_Hub" ? [each.value.sku_name] : []
    content {
      virtual_hub_id = var.hub_id[each.value.virtual_hub.virtual_hub_id]
    }
  }
  firewall_policy_id = azurerm_firewall_policy.fw_policy[each.value.firewall_policy].id
}

resource "azurerm_route_table" "rt" {
  for_each                      = var.route_tables
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = azurerm_firewall.fw[route.value.next_hop_in_ip_address].ip_configuration[0].private_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "srt" {
  for_each       = var.subnet_route_table_associations
  subnet_id      = var.subnet_ids[each.value.vnet_name][each.value.subnet_id]
  route_table_id = azurerm_route_table.rt[each.value.route_table_id].id
}