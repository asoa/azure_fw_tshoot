resource "azurerm_bastion_host" "bastion" {
  for_each            = var.bastions
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  tunneling_enabled   = each.value.tunneling_enabled

  ip_configuration {
    name                 = each.value.ip_configuration.name
    subnet_id            = var.subnet_ids[each.value.vnet_name][each.value.ip_configuration.subnet_id]
    public_ip_address_id = var.public_ips[each.value.ip_configuration.public_ip_address_id]
  }
}





