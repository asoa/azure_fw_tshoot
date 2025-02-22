output "app_gateways" {
  value = { for k, v in azurerm_application_gateway.gw : k => v.id }
}