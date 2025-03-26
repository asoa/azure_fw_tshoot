resource "azurerm_virtual_machine_run_command" "by_map" {
  for_each           = var.vm_run_commands
  name               = each.value.name
  location           = each.value.location
  virtual_machine_id = var.vm_ids[each.value.virtual_machine_id] # key from vm module map
  source {
    script = each.value.source.script
  }
}