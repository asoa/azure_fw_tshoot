variable "public_ips" {
  description = "map of VM public IPs from public_ip module"
  type        = map(any)
  default     = {}
}

variable "subnet_ids" {
  description = "A map of subnet IDs from internal network tier module"
  type        = map(any)
}

variable "bastions" {
  description = "Configuration for the bastion host"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    tunneling_enabled   = bool
    vnet_name           = optional(string)
    ip_configuration = object({
      name                 = string
      subnet_id            = string
      public_ip_address_id = string
    })
  }))
  default = {}
}