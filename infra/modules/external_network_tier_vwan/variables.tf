variable "virtual_wans" {
  description = "A map of Virtual WAN configurations."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    type                = string # default: Standard
  }))
}

variable "virtual_hubs" {
  description = "A map of Virtual Hub configurations."
  type = map(object({
    name                                   = string
    resource_group_name                    = string
    location                               = string
    address_prefix                         = string
    virtual_router_auto_scale_min_capacity = number
    hub_routing_preference                 = string # default: ExpressRoute
  }))
}

variable "hub_route_tables" {
  description = "A map of Virtual Hub Route Table configurations."
  type = map(object({
    name           = string
    virtual_hub_id = string
    route = object({
      name              = string
      destinations_type = string
      destinations      = list(string)
      next_hop_type     = string
      next_hop          = string
    })
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "A map of VPN Gateway configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    virtual_hub_id      = string
    scale_unit          = optional(number)
    routing_preference  = string # default: ExpressRoute
    bgp_settings = optional(object({
      asn         = number
      peer_weight = number
    }))
  }))
  default = {}
}

variable "virtual_hub_connections" {
  description = "A map of Virtual Hub Connection configurations."
  type = map(object({
    name                      = string
    virtual_hub_id            = string
    remote_virtual_network_id = string
    routing = optional(object({
      associated_route_table_id = optional(string)
    }))
  }))
}

variable "vnet_ids" {
  description = "A map of Virtual Network names to IDs from the network module"
  type        = map(string)
}