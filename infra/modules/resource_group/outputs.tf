# outputs a map of resource group names and their IDs
output "resource_groups" {
  value = { for rg in azurerm_resource_group.by_map : rg.name => rg.id }
}