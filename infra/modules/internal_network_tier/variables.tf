variable "security_groups" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules = list(object({
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

variable "networks" {
  description = "map of virtual networks"
  type = map(object({
    name                = string
    resource_group_name = string
    address_space       = list(string)
    location            = string
    dns_servers         = optional(list(string))
    route_table_id      = optional(string)
    subnet = optional(list(object({
      name             = string
      address_prefixes = list(string)
      # use "azurerm_subnet_network_security_group_association" for granular nsg -> subnet mapping
      security_group    = optional(string)
      service_endpoints = optional(list(string))
    })))
    enable_ddos_protection = optional(bool)
    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))
  }))
}

variable "virtual_network_peers" {
  type = map(object({
    name                      = string
    resource_group_name       = string
    virtual_network_name      = string
    remote_virtual_network_id = string
    allow_forwarded_traffic   = bool
  }))
  default = {}
}

variable "private_dns_zones" {
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "private_dns_zone_link" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    virtual_network_id    = string
    registration_enabled  = optional(bool)
  }))
  default = {}
}

variable "ddos_protection_plans" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
  default = {}
}