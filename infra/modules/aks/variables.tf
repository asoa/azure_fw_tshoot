variable "subnet_ids" {
  description = "map of subneet ids from the vnet module"
  type        = map(any)
}

variable "aks" {
  description = "The AKS cluster configuration"
  type = map(object({
    name                             = string
    location                         = string
    resource_group_name              = string
    dns_prefix                       = string
    kubernetes_version               = string
    local_account_disabled           = bool
    sku_tier                         = string
    private_cluster_enabled          = bool
    azure_policy_enabled             = bool
    http_application_routing_enabled = optional(bool)
    vnet_name                        = string
    default_node_pool = object({
      name                 = string
      node_count           = optional(number)
      vm_size              = string
      auto_scaling_enabled = optional(bool)
      min_count            = optional(number)
      max_count            = optional(number)
      os_sku               = string
      vnet_subnet_id       = string
    })
    azure_active_directory_role_based_access_control = object({
      azure_rbac_enabled     = bool
      admin_group_object_ids = list(string)
    })
    network_profile = object({
      network_plugin      = string
      network_plugin_mode = string
      network_policy      = string
      pod_cidr            = string
      service_cidr        = string
      dns_service_ip      = string
      outbound_type       = string
    })
    identity = object({
      type = string
    })
    tags = object({
      Environment = string
    })
  }))
}