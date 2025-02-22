resource "azurerm_traffic_manager_profile" "traffic_mgr" {
  for_each               = var.traffic_manager_profiles
  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  traffic_routing_method = each.value.traffic_routing_method
  dns_config {
    relative_name = each.value.dns_config.relative_name
    ttl           = each.value.dns_config.ttl
  }
  monitor_config {
    protocol                     = each.value.monitor_config.protocol
    port                         = each.value.monitor_config.port
    path                         = each.value.monitor_config.path
    interval_in_seconds          = each.value.monitor_config.interval_in_seconds
    timeout_in_seconds           = each.value.monitor_config.timeout_in_seconds
    tolerated_number_of_failures = each.value.monitor_config.tolerated_number_of_failures
  }
  tags = each.value.tags
}

resource "azurerm_traffic_manager_azure_endpoint" "endpoint" {
  for_each           = var.traffic_manager_endpoints
  name               = each.value.name
  profile_id         = azurerm_traffic_manager_profile.traffic_mgr[each.value.profile_id].id
  target_resource_id = var.endpoint_ids[each.key] # web app module exports key => app.id
  weight             = each.value.weight
  priority           = each.value.priority
}