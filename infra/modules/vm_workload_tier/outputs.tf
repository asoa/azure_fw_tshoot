output "vm_ids" {
  value = { for k, v in azurerm_windows_virtual_machine.vm : k => v.id }
}

# get all nic ids
output "nic_ids" {
  value = { for k, v in azurerm_network_interface.nic : k => v.id }
}

# get all vm ip addresses
output "backend_ip_addresses" {
  value = [for v in azurerm_network_interface.nic : v.private_ip_address]
}

# only get vm ids intended for backed pool
output "bep_nic_ids" {
  value = { for k, v in azurerm_network_interface.nic : k => v.id
    if strcontains(v.name, "bep")
  }
}

output "vm_identities" {
  value = { for k, v in azurerm_windows_virtual_machine.vm : k => v.identity[0] }
}

output "vm_ids_identities" {
  value = { for k, v in azurerm_windows_virtual_machine.vm : k => {
    "vm_id"       = v.id
    "vm_identity" = v.identity[0]
    }
  }
}