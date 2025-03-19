variable "networks" {
  description = "map of virtual networks"
  type = map(object({
    name                = string
    resource_group_name = string
    address_space       = list(string)
    location            = string
  }))
}

variable "subnets" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

variable "nsg_subnet_association" {
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))
  default = {}
}

variable "virtual_network_peers" {
  type = map(object({
    name                        = string
    resource_group_name         = string
    virtual_network_name        = string
    remote_virtual_network_name = string
    remote_virtual_network_id   = string
    allow_forwarded_traffic     = bool
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

variable "private_dns_zone_vnet_link" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    virtual_network_id    = string
    registration_enabled  = optional(bool)
    vnet_name             = optional(string)
  }))
  default = {}
}

variable "security_groups" {
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
}

variable "virtual_network_gateways" {
  description = "A map of virtual network gateways to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    type                = string
    vpn_type            = string
    active_active       = bool
    enable_bgp          = bool
    sku                 = string
    ip_configuration = object({
      name                          = string
      public_ip_address_id          = string
      private_ip_address_allocation = string
      subnet_id                     = string
      subnet_name                   = optional(string)
    })
    vpn_client_configuration = optional(object({
      address_space = list(string)
      root_certificate = optional(object({
        name             = string
        public_cert_data = string
      }))
    }))
  }))
  default = {}
}

# variable "virtual_network_gateway_connections" {
#   description = "A map of virtual network gateway connections to create"
#   type = map(object({
#     name                            = string
#     location                        = string
#     resource_group_name             = string
#     type                            = string
#     virtual_network_gateway_id      = string
#     peer_virtual_network_gateway_id = string
#     shared_key                      = string
#   }))
#   default = {}
# }