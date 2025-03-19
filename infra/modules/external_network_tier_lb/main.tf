resource "azurerm_lb" "lb" {
  for_each            = var.load_balancers
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  sku_tier            = each.value.sku_tier
  frontend_ip_configuration {
    name                          = each.value.frontend_ip_configuration.name
    private_ip_address_allocation = each.value.frontend_ip_configuration.private_ip_address_allocation
    public_ip_address_id          = var.internal_lb ? null : var.public_ips[each.key]
    subnet_id                     = var.subnet_ids[each.value.frontend_ip_configuration.vnet_name][each.value.frontend_ip_configuration.subnet_id]
  }
}

resource "azurerm_lb_backend_address_pool" "lb_pool" {
  for_each        = var.lb_backend_pools
  name            = each.value.name
  loadbalancer_id = azurerm_lb.lb[each.key].id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_bep" {
  for_each                = var.nic_bep_associations
  network_interface_id    = var.bep_nic_ids[each.key]
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool[each.value.backend_pool_key].id
  ip_configuration_name   = "ipconfig1"
}

resource "azurerm_lb_probe" "by_map" {
  for_each            = var.lb_probes
  name                = each.value.name
  loadbalancer_id     = azurerm_lb.lb[each.key].id
  protocol            = each.value.protocol
  port                = each.value.port
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
  probe_threshold     = each.value.probe_threshold
  request_path        = each.value.request_path
}

resource "azurerm_lb_rule" "by_map" {
  for_each                       = var.lb_rules
  loadbalancer_id                = azurerm_lb.lb[split("-", each.key)[0]].id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  probe_id                       = azurerm_lb_probe.by_map[split("-", each.key)[0]].id
  disable_outbound_snat          = each.value.disable_outbound_snat
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_pool[split("-", each.key)[0]].id]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.lb_network_security_group
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  security_rule       = each.value.security_rule
}

# associate nsg to subnet 
resource "azurerm_subnet_network_security_group_association" "by_map" {
  for_each                  = var.lb_subnet_nsg_associations
  subnet_id                 = var.subnet_ids[each.value.subnet_name]
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# resource "azurerm_lb_outbound_rule" "by_map" {
#   for_each                       = var.lb_outbound_rules
#   name                           = each.value.name
#   loadbalancer_id                = each.value.loadbalancer_id
#   protocol                       = each.value.protocol
#   backend_address_pool_id       = each.value.backend_address_pool_id
#   frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
# }