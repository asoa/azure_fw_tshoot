variable "public_ips" {
  description = "map of VM public IPs from public_ip module"
  type        = map(any)
}

variable "subnet_ids" {
  description = "A map of subnet IDs from internal network tier module"
  type        = map(any)
}

variable "bep_nic_ids" {
  description = "A map of nic ids from vm_workload_tier module"
  type        = map(any)
}

variable "internal_lb" {
  description = "deployed behind nva (e.g. azure firewall)"
  type        = bool
  default     = false
}

variable "load_balancers" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    sku_tier            = optional(string)
    frontend_ip_configuration = object({
      name                          = string
      public_ip_address_id          = optional(string) # dynamic from main.tf
      private_ip_address_allocation = string
      subnet_id                     = optional(string) # dynamic from main.tf
      vnet_name                     = optional(string)
    })
  }))
  default = {}
}

variable "lb_probes" {
  type = map(object({
    name                = string
    loadbalancer_id     = string
    protocol            = string
    port                = number
    interval_in_seconds = optional(number)
    number_of_probes    = optional(number)
    probe_threshold     = optional(number)
    request_path        = optional(string)
  }))
  default = {}
}

variable "lb_rules" {
  type = map(object({
    loadbalancer_id                = string
    name                           = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    probe_id                       = string
    disable_outbound_snat          = optional(bool)
    backend_address_pool_ids       = optional(list(string))
  }))
  default = {}
}

variable "lb_backend_pools" {
  description = "map of load balancer backend pools"
  type = map(object({
    name            = string
    loadbalancer_id = string
  }))
  default = {}
}

variable "nic_bep_associations" {
  type = map(object({
    network_interface_id    = string
    backend_address_pool_id = string
    backend_pool_key        = string
  }))
  default = {}
}

variable "lb_network_security_group" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rule = list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = string
      destination_port_range                     = string
      source_address_prefix                      = string
      destination_address_prefix                 = string
      description                                = string
      destination_address_prefixes               = list(string)
      destination_application_security_group_ids = list(string)
      destination_port_ranges                    = list(string)
      source_address_prefixes                    = list(string)
      source_application_security_group_ids      = list(string)
      source_port_ranges                         = list(string)
    }))
  }))
  default = {}
}

variable "lb_subnet_nsg_associations" {
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
    subnet_name               = optional(string) # use subnet_ids map
  }))
  default = {}
}