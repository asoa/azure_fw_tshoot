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

variable "root_public_certificate" {
  description = "The root public certificate for the VPN client configuration"
  type = map(object({
    name             = string
    public_cert_data = string
  }))
  default = <<EOT
  EOT
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
    shared_key                      = string
  }))
  default = {}
}