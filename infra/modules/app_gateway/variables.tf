variable "app_gateways" {
  description = "map of application gateways"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    gateway_ip_configuration = object({
      name        = string
      subnet_id   = string
      subnet_name = optional(string)
    })
    frontend_port = object({
      name = string
      port = number
    })
    frontend_ip_configuration = object({
      name                          = string
      public_ip_address_id          = string
      private_ip_address_allocation = optional(string)
    })
    backend_address_pool = object({
      name         = string
      ip_addresses = optional(list(string))
      fqdns        = optional(list(string))
    })
    backend_http_settings = object({
      name                                = string
      cookie_based_affinity               = string
      path                                = string
      port                                = number
      protocol                            = string
      request_timeout                     = number
      pick_host_name_from_backend_address = optional(string)
    })
    http_listener = object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      ssl_certificate_name           = optional(string)
    })
    request_routing_rule = object({
      name                       = string
      priority                   = number
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    })
  }))
}

variable "public_ips" {
  description = "output map object from public_ip module"
  type        = map(any)
}

variable "vnet_name" {
  description = "name of the virtual network"
  type        = string
}

variable "subnet_ids" {
  description = "output map of vent->subnets from internal_network_tier module"
  type        = map(any)
}

variable "backend_ip_addresses" {
  description = "list of backend ip addresses from vm workload tier module"
  type        = list(string)
  default     = []
}

variable "app_service_fqdns" {
  description = "list of app service fqdns from app_service module"
  type        = list(string)
  default     = []
}