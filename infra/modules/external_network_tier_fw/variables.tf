variable "hub_id" {
  description = "The ID of the virtual hub from the vwan module"
  type        = map(any)
  default     = {}
}

variable "backend_ip_addresses" {
  description = "A list of backend IP addresses from the vm module"
  type        = list(string)
  default     = []
}

variable "hub_ip" {
  description = "The public IP address of the hub_ip from data source"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A map of subnet IDs from the network module"
  type        = map(any)
}

variable "ip_ids" {
  description = "A map of public IP address IDs from the pip module"
  type        = map(string)
}

variable "ip_addresses" {
  description = "A map of public IP addresses from the pip module"
  type        = map(string)
  default     = {}
}

variable "firewall_policies" {
  description = "A map of firewall policies to create"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
  }))
}

variable "firewall_policy_rule_collection_groups" {
  description = "A map of firewall policy rule collection groups to create"
  type = map(object({
    name            = string
    firewall_policy = string
    priority        = number
    application_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name = string
        protocols = object({
          type = string
          port = number
        })
        source_addresses  = list(string)
        destination_fqdns = list(string)
      }))
    })))
    network_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
      }))
    })))
    nat_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                = string
        translated_address  = string
        translated_port     = number
        protocols           = list(string)
        source_addresses    = list(string)
        destination_address = string
        destination_ports   = list(string)
      }))
    })))
  }))
}

variable "firewalls" {
  description = "A map of firewalls to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku_name            = string
    sku_tier            = string
    ip_configuration = optional(object({
      name                 = string
      subnet_id            = optional(string)
      public_ip_address_id = string
    }))
    virtual_hub = optional(object({
      virtual_hub_id  = string
      public_ip_count = optional(number)
    }))
    firewall_policy = string
  }))
}

variable "route_tables" {
  description = "A map of route tables to create"
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    bgp_route_propagation_enabled = bool
    routes = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
}

variable "subnet_route_table_associations" {
  description = "A map of subnet route table associations to create"
  type = map(object({
    vnet_name      = string
    subnet_id      = string
    route_table_id = string
  }))
}