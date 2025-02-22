resource "azurerm_network_interface" "nic" {
  for_each              = var.network_interfaces
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  ip_forwarding_enabled = each.value.ip_forwarding_enabled

  ip_configuration {
    name                          = each.value.ip_configuration.name
    subnet_id                     = var.subnet_ids[each.value.ip_configuration.vnet_name][each.value.ip_configuration.subnet_id]
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    private_ip_address            = each.value.ip_configuration.private_ip_address
    public_ip_address_id          = contains(keys(var.public_ips), each.key) ? var.public_ips[each.key] : null
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each                   = var.virtual_machines
  name                       = each.value.name
  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  size                       = each.value.size
  admin_username             = each.value.admin_username
  admin_password             = each.value.admin_password
  network_interface_ids      = [azurerm_network_interface.nic[each.key].id]
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
}

locals {
  vm_disks = flatten([
    for disk_key, disk in var.managed_disks : [
      for vm_key, vm in var.virtual_machines :
      split("-", disk_key)[0] == vm.name ? # creates object only if disk and vm share same name/key
      {
        disk_key             = disk_key
        vm_key               = vm_key
        disk_name            = disk.name
        vm_name              = vm.name
        location             = vm.location
        resource_group_name  = vm.resource_group_name
        storage_account_type = disk.storage_account_type
        create_option        = disk.create_option
        source_resource_id   = disk.source_resource_id
        disk_size_gb         = disk.disk_size_gb
        lun                  = disk.lun
        caching              = disk.caching
      } : null
    ]
  ])
  disk_map = {
    for d in local.vm_disks : "${d.vm_key}-${d.disk_name}" => d
    if d != null
  }
}

resource "azurerm_managed_disk" "disk" {
  # create a unique map of each disk/vm pair
  for_each             = local.disk_map
  name                 = each.value.disk_name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  source_resource_id   = each.value.source_resource_id
  disk_size_gb         = each.value.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  for_each           = local.disk_map
  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm[each.value.vm_key].id
  lun                = each.value.lun
  caching            = each.value.caching
}