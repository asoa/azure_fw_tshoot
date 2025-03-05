subscription_id = "d48e2004-b787-4aed-800d-47e74f92afbb"

resource_groups = {
  hub = {
    name     = "<override in main>"
    location = "eastus2"
  }
  vm = {
    name     = "<override in main>"
    location = "eastus2"
  }
  aks = {
    name     = "<override in main>"
    location = "eastus2"
  }
}

public_ips = {
  fw = {
    name                = "fwpip"
    resource_group_name = "rg1"
    location            = "eastus2"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

networks = {
  hub = {
    name                   = "hub"
    resource_group_name    = "rg1"
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
    resource_group_name    = "rg1"
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
}

virtual_network_peers = {
  hub_to_vm = {
    name                         = "hub-to-vm"
    resource_group_name          = "rg1"
    virtual_network_name         = "hub"
    remote_virtual_network_id    = "vm"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
  vm_to_hub = {
    name                         = "vm-to-hub"
    resource_group_name          = "rg1"
    virtual_network_name         = "vm"
    remote_virtual_network_id    = "hub"
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
  }
}

# virtual machines

network_interfaces = {
  vm1 = {
    name                  = "vm1nic"
    resource_group_name   = "rg1"
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
    resource_group_name   = "rg1"
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
    resource_group_name   = "rg1"
    location              = "eastus2"
    size                  = "Standard_DS1_v2"
    admin_username        = "adminuser"
    admin_password        = "Tgjbh/pe2I72PD/XAzY9"
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
    resource_group_name   = "rg1"
    location              = "eastus2"
    size                  = "Standard_DS1_v2"
    admin_username        = "adminuser"
    admin_password        = "Tgjbh/pe2I72PD/XAzY9"
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
    resource_group_name = "rg1"
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
  lb = {
    loadbalancer_id                = "lb"
    name                           = "lb-rule"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
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
    resource_group_name = "rg1"
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
            name = "Allow-HTTP"
            protocols = {
              type = "Http"
              port = "80"
            }
            source_addresses  = ["*"]
            destination_fqdns = ["*.microsoft.com", "*.google.com"]
          },
          {
            name = "allow-msft-https"
            protocols = {
              type = "Https"
              port = 443
            }
            source_addresses  = ["*"]
            destination_fqdns = ["*.microsoft.com", "*.google.com"]
          }
        ]
      }
    ]
  },
  network-rule-collection = {
    name            = "network-rule-collection"
    firewall_policy = "fw-policy"
    priority        = 300
    network_rule_collections = [
      {
        name     = "vnet-rdp"
        priority = 310
        action   = "Allow"
        rules = [
          {
            name                  = "allow-vnet"
            protocols             = ["TCP"]
            source_addresses      = ["*"]
            destination_addresses = ["*"]
            destination_ports     = ["3389"]
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
    resource_group_name = "rg1"
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
  vm_to_hub = {
    name                          = "vm_to_hub"
    location                      = "eastus2"
    resource_group_name           = "rg1"
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
    subnet_id      = "BackendSubnet"
    route_table_id = "vm_to_hub"
  }
}