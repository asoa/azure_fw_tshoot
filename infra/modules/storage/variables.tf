variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet ids from the netowrk module"
}

variable "storage_accounts" {
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    account_tier                  = string
    account_replication_type      = string
    public_network_access_enabled = optional(bool)
    network_rules = optional(object({
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = list(string)
    }))
    tags = optional(map(string))
  }))
}


variable "storage_containers" {
  type = map(object({
    name                  = string
    storage_account_id    = string
    container_access_type = string
  }))
}

variable "storage_shares" {
  type = map(object({
    name               = string
    storage_account_id = string
    quota              = number
  }))
  default = {}
}