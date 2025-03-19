variable "subscription_id" {
  description = "The Azure subscription ID"
}

variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
}

# pip variables
variable "public_ips" {
  description = "map of public IPs"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
    sku                 = string
  }))
}

# network variables 

variable "security_groups" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules = list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = string
      destination_port_range                     = string
      source_address_prefix                      = string
      destination_address_prefix                 = string
      description                                = string
      destination_address_prefixes               = list(string)
      destination_application_security_group_ids = list(string)
      destination_port_ranges                    = list(string)
      source_address_prefixes                    = list(string)
      source_application_security_group_ids      = list(string)
      source_port_ranges                         = list(string)
    }))
  }))
  default = {}
}

variable "networks" {
  description = "map of virtual networks"
  type = map(object({
    name                = string
    resource_group_name = string
    address_space       = list(string)
    location            = string
    dns_servers         = optional(list(string))
    route_table_id      = optional(string)
    subnet = optional(list(object({
      name             = string
      address_prefixes = list(string)
      # use "azurerm_subnet_network_security_group_association" for granular nsg -> subnet mapping
      security_group    = optional(string)
      service_endpoints = optional(list(string))
    })))
    enable_ddos_protection = bool
    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))
  }))
}

variable "virtual_network_peers" {
  type = map(object({
    name                      = string
    resource_group_name       = string
    virtual_network_name      = string
    remote_virtual_network_id = string
    allow_forwarded_traffic   = bool
  }))
  default = {}
}

variable "private_dns_zones" {
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "private_dns_zone_link" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    virtual_network_id    = string
    registration_enabled  = optional(bool)
  }))
  default = {}
}

# virtual machine variables

variable "network_interfaces" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    location              = string
    ip_forwarding_enabled = optional(bool)
    ip_configuration = object({
      name                          = string
      vnet_name                     = optional(string)
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      public_ip_address_id          = optional(string)
    })
  }))
}

variable "virtual_machines" {
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    size                       = string
    admin_username             = string
    admin_password             = string
    network_interface_ids      = list(string)
    encryption_at_host_enabled = optional(bool)
    hyper_v_generation         = optional(string)
    os_disk = object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
    })
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    identity = optional(object({
      type = string
    }))
    zones = optional(list(string))
  }))
}

variable "vm_run_commands" {
  description = "map of virtual machine run command"
  type = map(object({
    name               = string
    vm_name            = string
    location           = string
    virtual_machine_id = string # override in main.tf
    source = object({
      script = string
    })
  }))
}

# load balancer variables

variable "internal_lb" {
  description = "deployed behind nva (e.g. azure firewall)"
  type        = bool
  default     = false
}

variable "load_balancers" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    sku_tier            = optional(string)
    frontend_ip_configuration = object({
      name                          = string
      public_ip_address_id          = optional(string) # dynamic from main.tf
      private_ip_address_allocation = string
      subnet_id                     = optional(string) # dynamic from main.tf
      vnet_name                     = optional(string)

    })
  }))
  default = {}
}

variable "lb_probes" {
  type = map(object({
    name                = string
    loadbalancer_id     = string
    protocol            = string
    port                = number
    interval_in_seconds = optional(number)
    number_of_probes    = optional(number)
    probe_threshold     = optional(number)
    request_path        = optional(string)
  }))
  default = {}
}

variable "lb_rules" {
  type = map(object({
    loadbalancer_id                = string
    name                           = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    probe_id                       = string
    disable_outbound_snat          = optional(bool)
    backend_address_pool_ids       = optional(list(string))
  }))
  default = {}
}

variable "lb_backend_pools" {
  description = "map of load balancer backend pools"
  type = map(object({
    name            = string
    loadbalancer_id = string
  }))
  default = {}
}

variable "nic_bep_associations" {
  type = map(object({
    network_interface_id    = string
    backend_address_pool_id = string
    backend_pool_key        = string
  }))
  default = {}
}

variable "lb_network_security_group" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rule = list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = string
      destination_port_range                     = string
      source_address_prefix                      = string
      destination_address_prefix                 = string
      description                                = string
      destination_address_prefixes               = list(string)
      destination_application_security_group_ids = list(string)
      destination_port_ranges                    = list(string)
      source_address_prefixes                    = list(string)
      source_application_security_group_ids      = list(string)
      source_port_ranges                         = list(string)
    }))
  }))
  default = {}
}

variable "lb_subnet_nsg_associations" {
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
    subnet_name               = optional(string) # use subnet_ids map
  }))
  default = {}
}

# firewall variables

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

# aks variables
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