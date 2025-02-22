output "hub_id" {
  value = { for k, v in azurerm_virtual_hub.hub : k => v.id }
}