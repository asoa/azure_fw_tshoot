resource "azurerm_storage_account" "sa" {
  for_each                 = var.storage_accounts
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  tags                     = each.value.tags
}

resource "azurerm_storage_container" "sc" {
  for_each              = var.storage_containers
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.sa[each.key].id
  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_blob" "scripts" {
  name                   = var.script_name
  storage_account_name   = var.storage_accounts["vmautomation"].name
  storage_container_name = "scripts"
  type                   = "Block"
  source                 = "scripts/${var.script_name}"
  depends_on             = [azurerm_storage_container.sc["vmautomation"]]
}

resource "azurerm_role_assignment" "sa_rbac" {
  for_each             = var.vm_identities
  scope                = azurerm_storage_account.sa["vmautomation"].id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.vm_identities[each.key].principal_id
  depends_on           = [azurerm_storage_account.sa["vmautomation"]]
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  for_each             = var.vm_ids
  name                 = "customScript1"
  virtual_machine_id   = each.value
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings = jsonencode({
    "fileUris" : [
      "${azurerm_storage_blob.scripts.url}"
    ],
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -File Install_IIS.ps1"
  })
  # To use the system-assigned identity on the target VM or Virtual Machine Scale Set, set managedidentity to an empty JSON object.
  protected_settings = jsonencode({
    "managedIdentity" : {}
  })
}

resource "azurerm_virtual_machine_run_command" "by_map" {
  for_each           = var.vm_run_commands
  name               = each.value.name
  location           = each.value.location
  virtual_machine_id = each.value.virtual_machine_id # override in main.tf
  source {
    script = each.value.source.script
  }
}