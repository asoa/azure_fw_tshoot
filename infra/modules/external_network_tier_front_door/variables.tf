variable "default_hostnames" {
  type        = map(any)
  description = "map of default hostnames from the app service module"
}

variable "frontdoor_profiles" {
  type = map(object({
    name                = string
    resource_group_name = string
    sku_name            = string # Standard_AzureFrontDoor / Premium_AzureFrontDoor
    health_probe = object({
      protocol            = string
      interval_in_seconds = number
      request_type        = string
      path                = string
    })
    load_balancing = object({
      additional_latency_in_milliseconds = number
      sample_size                        = number
      successful_samples_required        = number
    })
    supported_protocols    = list(string)
    patterns_to_match      = list(string)
    forwarding_protocol    = string
    link_to_default_domain = bool
    https_redirect_enabled = bool
  }))
  description = "map of frontdoor profiles to create"
}

variable "front_door_origins" {
  type = map(object({
    name                           = string
    cdn_frontdoor_origin_group_id  = string
    enabled                        = bool
    host_name                      = string
    http_port                      = number
    https_port                     = number
    origin_host_header             = optional(string)
    priority                       = number
    weight                         = number
    certificate_name_check_enabled = bool
  }))
  description = "map of frontdoor origins to create"
}