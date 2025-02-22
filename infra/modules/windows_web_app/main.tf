resource "random_id" "rand" {
  byte_length = 4
}

resource "azurerm_service_plan" "asp" {
  for_each               = var.service_plans
  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  os_type                = each.value.os_type
  sku_name               = each.value.sku_name
  zone_balancing_enabled = each.value.zone_balancing_enabled
}

resource "azurerm_windows_web_app" "app" {
  for_each                      = var.windows_web_apps
  name                          = "${each.value.name}-${random_id.rand.hex}"
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  service_plan_id               = azurerm_service_plan.asp[each.value.service_plan_id].id
  public_network_access_enabled = each.value.public_network_access_enabled
  site_config {}
}

resource "azurerm_windows_web_app_slot" "app_slot" {
  for_each                                 = var.windows_web_apps_slots
  name                                     = each.value.name
  app_service_id                           = azurerm_windows_web_app.app[each.value.app_service_id].id
  ftp_publish_basic_authentication_enabled = each.value.ftp_publish_basic_authentication_enabled
  public_network_access_enabled            = each.value.public_network_access_enabled
  site_config {
    application_stack {
      current_stack       = each.value.site_config.application_stack.current_stack
      dotnet_core_version = each.value.site_config.application_stack.current_stack == "dotnetcore" ? each.value.site_config.application_stack.dotnet_core_version : null
      dotnet_version      = each.value.site_config.application_stack.current_stack == "dotnet" ? each.value.site_config.application_stack.dotnet_version : null
    }
    ftps_state = each.value.site_config.ftps_state
  }
}

resource "azurerm_app_service_source_control_slot" "app_slot_source_control" {
  for_each      = var.windows_web_apps_slots
  slot_id       = azurerm_windows_web_app_slot.app_slot[each.key].id
  use_local_git = each.value.use_local_git
}


