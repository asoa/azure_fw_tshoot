variable "location" {
  description = "The Azure location where the resources will be created."
  type        = string
}

variable "azcr" {
  description = "The Azure Container Registry configuration."
  type = object({
    name                = string
    sku                 = string
    admin_enabled       = optional(bool)
    resource_group_name = string
    location            = string
  })
}