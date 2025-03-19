subscription_id = "<subscription_id>"

resource_groups = {
  hub = {
    name     = "hub"
    location = "eastus2"
  }
  vm = {
    name     = "vm"
    location = "eastus2"
  }
  aks = {
    name     = "aks"
    location = "eastus2"
  }
}

public_ips = {
  fw = {
    name                = "fw"
    resource_group_name = "rg-jpes-hub"
    location            = "eastus2"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

networks = {
  hub = {
    name                   = "hub"
    resource_group_name    = "rg-jpes-hub"
    address_space          = ["10.10.0.0/16"]
    location               = "eastus2"
    enable_ddos_protection = false
    subnet = [
      {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.10.0.0/26"]
      }
    ]
  }
  vm = {
    name                   = "vm"
    resource_group_name    = "rg-jpes-hub"
    address_space          = ["10.11.0.0/16"]
    location               = "eastus2"
    enable_ddos_protection = false
    subnet = [
      {
        name             = "BackendSubnet"
        address_prefixes = ["10.11.1.0/24"]
      }
    ]
  }
  aks = {
    name                   = "aks"
    resource_group_name    = "rg-jpes-hub"
    address_space          = ["10.12.0.0/16"]
    location               = "eastus2"
    enable_ddos_protection = false
    subnet = [
      {
        name             = "AKSSubnet"
        address_prefixes = ["10.12.0.0/24"]
      }
    ]
  }
}

virtual_network_peers = {
  hub_to_vm = {
    name                         = "hub-to-vm"
    resource_group_name          = "rg-jpes-hub"
    virtual_network_name         = "hub"
    remote_virtual_network_id    = "vm"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
  vm_to_hub = {
    name                         = "vm-to-hub"
    resource_group_name          = "rg-jpes-hub"
    virtual_network_name         = "vm"
    remote_virtual_network_id    = "hub"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
  aks_to_hub = {
    name                         = "aks-to-hub"
    resource_group_name          = "rg-jpes-hub"
    virtual_network_name         = "aks"
    remote_virtual_network_id    = "hub"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
  hub_to_aks = {
    name                         = "hub-to-aks"
    resource_group_name          = "rg-jpes-hub"
    virtual_network_name         = "hub"
    remote_virtual_network_id    = "aks"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
  aks_to_vm = {
    name                         = "aks-to-vm"
    resource_group_name          = "rg-jpes-hub"
    virtual_network_name         = "aks"
    remote_virtual_network_id    = "vm"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
  vm_to_aks = {
    name                         = "vm-to-aks"
    resource_group_name          = "rg-jpes-hub"
    virtual_network_name         = "vm"
    remote_virtual_network_id    = "aks"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
}

# virtual machines

network_interfaces = {
  vm1 = {
    name                  = "vm1nic"
    resource_group_name   = "rg-jpes-vm"
    location              = "eastus2"
    ip_forwarding_enabled = false
    ip_configuration = {
      name                          = "ipconfig1"
      vnet_name                     = "vm"
      subnet_id                     = "BackendSubnet"
      private_ip_address_allocation = "Dynamic"
    }
  }
  vm2 = {
    name                  = "vm2nic"
    resource_group_name   = "rg-jpes-vm"
    location              = "eastus2"
    ip_forwarding_enabled = false
    ip_configuration = {
      name                          = "ipconfig1"
      vnet_name                     = "vm"
      subnet_id                     = "BackendSubnet"
      private_ip_address_allocation = "Dynamic"
    }
  }
}

virtual_machines = {
  vm1 = {
    name                  = "vm1"
    resource_group_name   = "rg-jpes-vm"
    location              = "eastus2"
    size                  = "Standard_DS1_v2"
    admin_username        = "adminuser"
    admin_password        = "<password>"
    network_interface_ids = ["vm1nic"]
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-Datacenter"
      version   = "latest"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
  vm2 = {
    name                  = "vm2"
    resource_group_name   = "rg-jpes-vm"
    location              = "eastus2"
    size                  = "Standard_DS1_v2"
    admin_username        = "adminuser"
    admin_password        = "<password>"
    network_interface_ids = ["vm2nic"]
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-Datacenter"
      version   = "latest"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

vm_run_commands = {
  vm1 = {
    name               = "vm1-run-command"
    vm_name            = "vm1"
    location           = "eastus2"
    virtual_machine_id = "vm1"
    source = {
      script = <<-EOT
        Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Install-WindowsFeature -Name "Web-Server" -IncludeManagementTools' -Wait
        Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Remove-Item "C:\\inetpub\\wwwroot\\iisstart.htm"' -Wait
        Add-Content -Path 'C:\inetpub\wwwroot\iisstart.htm' -Value $("Hello World from: {0}" -f $env:computername)
      EOT
    }
  }
  vm2 = {
    name               = "vm2-run-command"
    vm_name            = "vm2"
    location           = "eastus2"
    virtual_machine_id = "vm2"
    source = {
      script = <<-EOT
        Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Install-WindowsFeature -Name "Web-Server" -IncludeManagementTools' -Wait
        Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Remove-Item "C:\\inetpub\\wwwroot\\iisstart.htm"' -Wait
        Add-Content -Path 'C:\inetpub\wwwroot\iisstart.htm' -Value $("Hello World from: {0}" -f $env:computername)
      EOT
    }
  }
}

# load balancer

internal_lb = true

load_balancers = {
  lb = {
    name                = "lb"
    location            = "eastus2"
    resource_group_name = "rg-jpes-hub"
    sku                 = "Standard"
    sku_tier            = "Regional"
    frontend_ip_configuration = {
      name                          = "frontend"
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = "BackendSubnet"
      vnet_name                     = "vm"
    }
  }
}

lb_probes = {
  lb = {
    name            = "lb-probe"
    loadbalancer_id = "lb"
    protocol        = "Tcp"
    port            = 80
  }
}

lb_rules = {
  lb-80 = {
    loadbalancer_id                = "lb"
    name                           = "lb-rule"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "frontend"
    probe_id                       = "lb-probe"
    disable_outbound_snat          = true
  }
  lb-3389 = {
    loadbalancer_id                = "lb"
    name                           = "lb-rule-rdp"
    protocol                       = "Tcp"
    frontend_port                  = 3389
    backend_port                   = 3389
    frontend_ip_configuration_name = "frontend"
    probe_id                       = "lb-probe"
    disable_outbound_snat          = true
  }
}

lb_backend_pools = {
  lb = {
    name            = "lb-pool"
    loadbalancer_id = "lb"
  }
}

nic_bep_associations = {
  vm1 = {
    network_interface_id    = "vm1nic"
    backend_address_pool_id = "<override in main>"
    backend_pool_key        = "lb"
  }
  vm2 = {
    network_interface_id    = "vm2nic"
    backend_address_pool_id = "<override in main>"
    backend_pool_key        = "lb"
  }
}

firewall_policies = {
  fw-policy = {
    name                = "fw-policy"
    resource_group_name = "rg-jpes-hub"
    location            = "eastus2"
  }
}

firewall_policy_rule_collection_groups = {
  dnat-rule-collection = {
    name            = "nat-rule-collection"
    firewall_policy = "fw-policy"
    priority        = 100
    nat_rule_collections = [
      {
        name     = "dnat-rdp"
        priority = 110
        action   = "Dnat"
        rules = [
          {
            name                = "allow-rdp"
            translated_address  = "<lb_ip>"
            translated_port     = 3389
            protocols           = ["TCP"]
            source_addresses    = ["*"]
            destination_address = "fw" # key value in map from input variable ip_addresses
            destination_ports   = ["3389"]
          },
          {
            name                = "allow-http"
            translated_address  = "<lb_ip>"
            translated_port     = 80
            protocols           = ["TCP"]
            source_addresses    = ["*"]
            destination_address = "fw" # key value in map from input variable ip_addresses
            destination_ports   = ["80"]
          }
        ]
      }
    ]
  },
  application-rule-collection = {
    name            = "app-rule-collection"
    firewall_policy = "fw-policy"
    priority        = 200
    application_rule_collections = [
      {
        name     = "Allow-HTTP"
        action   = "Allow"
        priority = 210
        rules = [
          {
            name = "allow-http-testing"
            protocols = {
              type = "Http"
              port = "80"
            }
            source_addresses  = ["*"]
            destination_fqdns = ["*"]
          },
          {
            name = "allow-https-testing"
            protocols = {
              type = "Https"
              port = "443"
            }
            source_addresses  = ["*"]
            destination_fqdns = ["*"]
          }
          # {
          #   name = "Allow-HTTP"
          #   protocols = {
          #     type = "Http"
          #     port = "80"
          #   }
          #   source_addresses  = ["*"]
          #   destination_fqdns = ["*.microsoft.com", "*.google.com"]
          # },
          # {
          #   name = "allow-msft-https"
          #   protocols = {
          #     type = "Https"
          #     port = 443
          #   }
          #   source_addresses = ["*"]
          #   destination_fqdns = ["*.microsoft.com", "*.google.com", "portal.azure.com", "login.microsoftonline.com",
          #     "aadcdn.msftauth.net", "login.live.com", "*.privatelink.eastus2.azmk8s.io"
          #   ]
          # },
          # {
          #   name = "allow-aks-global"
          #   protocols = {
          #     type = "Https"
          #     port = 443
          #   }
          #   source_addresses = ["*"]
          #   destination_fqdns = [
          #     "*.hcp.eastus2.azmk8s.io",
          #     "mcr.microsoft.com",
          #     "*.data.mcr.microsoft.com",
          #     "mcr-0001.mcr-msedge.net",
          #     "management.azure.com",
          #     "login.microsoftonline.com",
          #     "packages.microsoft.com",
          #     "acs-mirror.azureedge.net",
          #     "packages.aks.azure.com"
          #   ]
          # }
        ]
      }
    ]
  },
  network-rule-collection = {
    name            = "network-rule-collection"
    firewall_policy = "fw-policy"
    priority        = 300
    network_rule_collections = [
      # {
      #   name     = "vnet-rdp"
      #   priority = 310
      #   action   = "Allow"
      #   rules = [
      #     {
      #       name                  = "allow-vnet"
      #       protocols             = ["TCP"]
      #       source_addresses      = ["*"]
      #       destination_addresses = ["*"]
      #       destination_ports     = ["3389"]
      #     }
      #   ]
      # }
      # {
      #   name    = "aks"
      #   priority = 320
      #   action   = "Allow"
      #   rules = [
      #     {
      #       name                  = "allow-aks-global"
      #       protocols             = ["UDP", "TCP"]
      #       source_addresses      = ["*"]
      #       destination_addresses = ["*"]
      #       destination_ports     = ["1194", "9000", "123"]
      #     }
      #   ]
      # }
      {
        name     = "aks-outbound"
        priority = 320
        action   = "Allow"
        rules = [
          {
            name                  = "allow-aks-outbound"
            protocols             = ["Any"]
            source_addresses      = ["10.12.0.0/24"]
            destination_addresses = ["*"]
            destination_ports     = ["*"]
          }
        ]
      },
      {
        name     = "allow-vm-subnet"
        priority = 330
        action   = "Allow"
        rules = [
          {
            name                  = "allow-vm-subnet-to-any"
            protocols             = ["Any"]
            source_addresses      = ["10.11.1.0/24"]
            destination_addresses = ["*"]
            destination_ports     = ["*"]
          }
        ]
      }
    ]
  }
}

firewalls = {
  "fw" = {
    name                = "fw"
    location            = "eastus2"
    resource_group_name = "rg-jpes-hub"
    sku_name            = "AZFW_VNet"
    sku_tier            = "Standard"
    ip_configuration = {
      name                 = "ipconfig1"
      subnet_id            = "AzureFirewallSubnet"
      public_ip_address_id = "fw"
    }
    firewall_policy = "fw-policy"
  }
}

route_tables = {
  spokes_to_hub = {
    name                          = "spokes_to_hub"
    location                      = "eastus2"
    resource_group_name           = "rg-jpes-hub"
    bgp_route_propagation_enabled = false
    routes = {
      default = {
        name                   = "default"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "fw"
      }
    }
  }
}

subnet_route_table_associations = {
  vm_to_hub = {
    vnet_name      = "vm"
    subnet_id      = "BackendSubnet"
    route_table_id = "spokes_to_hub"
  }
  aks_to_hub = {
    vnet_name      = "aks"
    subnet_id      = "AKSSubnet"
    route_table_id = "spokes_to_hub"
  }
}

# aks cluster
aks = {
  "cluster1" = {
    name                    = "aks-cluster"
    location                = "eastus2"
    resource_group_name     = "rg-jpes-aks"
    dns_prefix              = "aks-cluster"
    kubernetes_version      = "1.30.5"
    local_account_disabled  = true
    sku_tier                = "Standard"
    private_cluster_enabled = true
    azure_policy_enabled    = true
    azure_rbac_enabled      = true
    vnet_name               = "aks"
    default_node_pool = {
      name       = "default"
      node_count = 3
      vm_size    = "Standard_D4s_v3"
      # auto_scaling_enabled = true
      # min_count            = 1
      # max_count            = 3
      os_sku         = "AzureLinux"
      vnet_subnet_id = "AKSSubnet"
    }
    azure_active_directory_role_based_access_control = {
      azure_rbac_enabled     = true
      admin_group_object_ids = ["7b7df0e0-5d8f-427a-b6c7-c842066ef297"]
    }
    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
      network_policy      = "calico"
      pod_cidr            = "192.168.0.0/16" # Required for Azure CNI Overlay
      service_cidr        = "10.0.0.0/16"
      dns_service_ip      = "10.0.0.10"
      outbound_type       = "userDefinedRouting"
    }
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      Environment = "dev"
    }
  }
}


