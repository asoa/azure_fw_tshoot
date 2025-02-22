output "vnet_ids" {
  value = { for k, v in azurerm_virtual_network.nw : k => v.id }
}

# map of nw and subnet ids
output "subnet_ids" {
  value = { for vnet_key, vnet in azurerm_virtual_network.nw : vnet_key => {
    for subnet in vnet.subnet :
    subnet.name => subnet.id
    }
  }
}

# flattend list of subnet ids
output "flatten_subnet_ids" {
  value = flatten([for vnet in azurerm_virtual_network.nw : [
    for subnet in vnet.subnet : subnet.name == "private" ? [subnet.id] : []
  ]])
}