output "key_vaults" {
  value = { for kv in azurerm_key_vault.by_map : kv.name => kv.id }
}