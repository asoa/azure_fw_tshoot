variable "traffic_manager_profiles" {
  description = "A map of Traffic Manager profiles to create"
  type = map(object({
    name                   = string
    resource_group_name    = string
    traffic_routing_method = string
    dns_config = object({
      relative_name = string
      ttl           = number
    })
    monitor_config = object({
      protocol                     = string
      port                         = number
      path                         = string
      interval_in_seconds          = number
      timeout_in_seconds           = number
      tolerated_number_of_failures = number
    })
    tags = optional(map(string))
  }))
}

variable "traffic_manager_endpoints" {
  description = "A map of Traffic Manager endpoints to create"
  type = map(object({
    name               = string
    profile_id         = string
    target_resource_id = string
    weight             = optional(number)
    priority           = optional(number)
  }))
}

variable "endpoint_ids" {
  description = "A map of Traffic Manager endpoints from other modules"
  type        = map(any)
}

# variable "traffic_mgr_name" {
#   description = "The name of the Traffic Manager profile"
#   type        = string
# }