variable "public_ips" {
  description = "map of VM public IPs from public_ip module"
  type        = map(any)
}

variable "virtual_network_gateways" {
  description = "A map of virtual network gateways (vpn / express route) to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    type                = string
    vpn_type            = optional(string)
    active_active       = optional(bool)
    enable_bgp          = optional(bool)
    sku                 = optional(string)
    ip_configuration = object({
      name                          = string
      public_ip_address_id          = string
      private_ip_address_allocation = string
      subnet_id                     = string
      subnet_name                   = optional(string)
    })
    vpn_client_configuration = optional(object({
      address_space = optional(list(string))
      root_certificate = optional(object({
        name             = string
        public_cert_data = string
      }))
    }))
  }))
  default = {}
}

variable "root_public_certificate" {
  description = "The root public certificate for the VPN client configuration"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A map of subnet IDs from module output"
  type        = map(string)
  default     = {}
}

variable "virtual_network_gateway_connections" {
  description = "A map of virtual network gateway connections to create"
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    type                            = string
    virtual_network_gateway_id      = string
    peer_virtual_network_gateway_id = string
    shared_key                      = optional(string)
  }))
  default = {}
}

variable "express_route_circuits" {
  description = "A map of express route circuits to create"
  type = map(object({
    name                  = string
    resource_group_name   = string
    location              = string
    service_provider_name = string
    peering_location      = string
    bandwidth_in_mbps     = number
    sku = object({
      tier   = string
      family = string
    })
  }))
  default = {}
}

# variable "shared_key" {
#   description = "The shared key for the VPN connection"
#   type        = string
#   default     = ""
# }