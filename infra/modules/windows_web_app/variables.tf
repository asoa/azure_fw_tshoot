variable "service_plans" {
  description = "map of service plans"
  type = map(object({
    name                   = string
    resource_group_name    = string
    location               = string
    os_type                = string
    sku_name               = string
    zone_balancing_enabled = optional(bool)
    tags                   = optional(map(string))
  }))
}

variable "windows_web_apps" {
  description = "map of web apps"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    service_plan_id               = string
    public_network_access_enabled = optional(bool)
    site_config                   = object({})
  }))
}

variable "windows_web_apps_slots" {
  description = "map of web apps slots"
  type = map(object({
    name                                     = string
    app_service_id                           = string
    ftp_publish_basic_authentication_enabled = optional(bool)
    site_config = object({
      application_stack = object({
        current_stack       = string
        dotnet_version      = optional(string)
        dotnet_core_version = optional(string)
      })
      ftps_state = optional(string)
    })
    use_local_git = optional(bool)
  }))
  validation {
    condition     = alltrue([for k, v in var.windows_web_apps_slots : contains(["dotnet", "dotnetcore"], v.site_config.application_stack.current_stack)])
    error_message = "Invalid value for current_stack. Allowed values are 'dotnet' or 'dotnetcore'."
  }
}

# variable "windows_web_apps_slots_source_control" {
#   description = "map of web apps slots source control"
#   type = map(object({
#     slot_id       = string # overried in main.tf
#     branch        = optional(string)
#     branch_url    = optional(string)
#     use_local_git = bool
#   }))
# }