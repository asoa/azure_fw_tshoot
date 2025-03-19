# outputs a map of resource group names
output "resource_group_names" {
  value = { for k, v in azurerm_resource_group.by_map : k => v.name }
}