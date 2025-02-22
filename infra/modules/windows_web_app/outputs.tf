output "app_service_plan_ids" {
  value = { for k, v in azurerm_service_plan.asp : k => v.id }
}

output "windows_web_app_ids" {
  value = { for k, v in azurerm_windows_web_app.app : k => v.id }
}

output "windows_web_app_slot_ids" {
  value = { for k, v in azurerm_windows_web_app_slot.app_slot : k => v.id }
}

output "default_hostnames" {
  value = { for k, v in azurerm_windows_web_app.app : k => v.default_hostname }
}