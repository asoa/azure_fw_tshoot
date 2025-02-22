resource "azurerm_windows_virtual_machine_scale_set" "by_map" {
  for_each             = var.virtual_machines
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  sku                  = each.value.sku
  instances            = each.value.instances
  admin_username       = each.value.admin_username
  admin_password       = each.value.admin_password
  computer_name_prefix = each.value.computer_name_prefix
  network_interface {
    name    = each.value.network_interface.name
    primary = each.value.network_interface.primary
    ip_configuration {
      name                                   = each.value.network_interface.ip_configuration.name
      primary                                = each.value.network_interface.ip_configuration.primary
      subnet_id                              = each.value.network_interface.ip_configuration.subnet_id
      load_balancer_backend_address_pool_ids = each.value.network_interface.ip_configuration.load_balancer_backend_address_pool_ids
    }
  }
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
    disk_size_gb         = each.value.os_disk.disk_size_gb
  }
  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
  identity {
    type = each.value.identity.type
  }
  zones        = each.value.zones
  upgrade_mode = each.value.upgrade_mode
}

# resource "azurerm_network_interface" "by_map" {
#   for_each              = var.network_interfaces
#   name                  = each.value.name
#   resource_group_name   = each.value.resource_group_name
#   location              = each.value.location
#   ip_forwarding_enabled = each.value.ip_forwarding_enabled

#   ip_configuration {
#     name                          = each.value.ip_configuration.name
#     subnet_id                     = each.value.ip_configuration.subnet_id
#     private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
#     private_ip_address            = each.value.ip_configuration.private_ip_address
#     public_ip_address_id          = each.value.ip_configuration.public_ip_address_id
#   }
# }