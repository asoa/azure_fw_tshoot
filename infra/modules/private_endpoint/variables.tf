variable "vnet_ids" {
  description = "A map of virtual network IDs from the network module"
  type        = map(string)
}

variable "private_endpoints" {
  description = "A map of private endpoints to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    private_service_connection_name = object({
      name                           = string
      private_connection_resource_id = string
      subresource_names              = list(string)
      is_manual_connection           = bool
    })
    private_dns_zone_group = object({
      name                 = string
      private_dns_zone_ids = list(string)
    })
  }))
}

variable "private_dns_zones" {
  description = "A map of private DNS zones to create"
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}

variable "private_dns_zone_virtual_network_links" {
  description = "A map of private DNS zone virtual network links to create"
  type = map(object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    virtual_network_id    = string
  }))
}