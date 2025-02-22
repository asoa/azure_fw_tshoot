
output "storage_accounts" {
  value = {
    for k, v in azurerm_storage_account.sa : k => v.id
  }
}