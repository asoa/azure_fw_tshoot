variable "public_ips" {
  description = "map of VM public IPs from public_ip module"
  type        = map(any)
  default     = {}
}

variable "subnet_ids" {
  type        = map(any)
  description = "map of key value pairs for subnet ids from internal network tier module"
}

# variable "vnet_name" {
#   description = "The name of the virtual network for backend servers"
#   type        = string
# }

variable "network_interfaces" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    location              = string
    ip_forwarding_enabled = optional(bool)
    ip_configuration = object({
      name                          = string
      vnet_name                     = optional(string)
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      public_ip_address_id          = optional(string)
    })
  }))
}

variable "managed_disks" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    storage_account_type = string
    create_option        = string
    source_resource_id   = optional(string)
    disk_size_gb         = number
    lun                  = number
    caching              = string
  }))
  default = {}
}

variable "data_disk_attachments" {
  type = map(object({
    virtual_machine_id = string
    managed_disk_id    = string
    lun                = number
    caching            = string
  }))
  default = {}
}

variable "virtual_machines" {
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    size                       = string
    admin_username             = string
    admin_password             = string
    network_interface_ids      = list(string)
    encryption_at_host_enabled = optional(bool)
    hyper_v_generation         = optional(string)
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
    zones = optional(list(string))
  }))
}