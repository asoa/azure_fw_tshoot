resource "random_id" "front_door_endpoint_name" {
  byte_length = 4
}

resource "azurerm_cdn_frontdoor_profile" "fdp" {
  for_each            = var.frontdoor_profiles
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "fde" {
  for_each                 = var.frontdoor_profiles
  name                     = "afd-${random_id.front_door_endpoint_name.hex}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdp[each.key].id
}

resource "azurerm_cdn_frontdoor_origin_group" "fdog" {
  for_each                                                  = var.frontdoor_profiles
  name                                                      = "${each.value.name}-origin-group"
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdp[each.key].id
  session_affinity_enabled                                  = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
  health_probe {
    protocol            = each.value.health_probe.protocol
    interval_in_seconds = each.value.health_probe.interval_in_seconds
    request_type        = each.value.health_probe.request_type
    path                = each.value.health_probe.path
  }
  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }
}

resource "azurerm_cdn_frontdoor_origin" "fdo" {
  # for_each                         = var.site_hostnames # map of site hostnames exported from the app service module
  for_each                       = var.front_door_origins
  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdog[each.value.cdn_frontdoor_origin_group_id].id
  host_name                      = var.default_hostnames[each.key] # use map from app service module output
  origin_host_header             = var.default_hostnames[each.key]
  priority                       = each.value.priority
  weight                         = each.value.weight
  enabled                        = each.value.enabled
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
}

resource "azurerm_cdn_frontdoor_route" "route" {
  for_each                      = var.frontdoor_profiles
  name                          = "${each.value.name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fde[each.key].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdog[each.key].id
  cdn_frontdoor_origin_ids      = [for origin in azurerm_cdn_frontdoor_origin.fdo : origin.id]
  supported_protocols           = each.value.supported_protocols
  patterns_to_match             = each.value.patterns_to_match
  forwarding_protocol           = each.value.forwarding_protocol
  link_to_default_domain        = each.value.link_to_default_domain
  https_redirect_enabled        = each.value.https_redirect_enabled
}