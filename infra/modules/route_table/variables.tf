variable "route_tables" {
  description = "map of route tables"
  type = map(object({
    name                          = string
    location                      = string
    bgp_route_propagation_enabled = optional(bool)
    resource_group_name           = string
    route = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))
}