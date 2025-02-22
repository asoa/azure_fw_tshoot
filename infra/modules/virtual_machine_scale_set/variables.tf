variable "virtual_machines" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    sku                  = string
    instances            = number
    admin_username       = string
    admin_password       = string
    computer_name_prefix = optional(string)
    network_interface = object({
      name    = string
      primary = bool
      ip_configuration = object({
        name                                   = string
        primary                                = bool
        subnet_id                              = string
        load_balancer_backend_address_pool_ids = optional(list(string))
      })
    })
    encryption_at_host_enabled = optional(bool)
    os_disk = object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
    })
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    identity = optional(object({
      type = string
    }))
    zones        = list(string)
    upgrade_mode = optional(string)
  }))
}