module "rg" {
  source          = "./modules/resource_group"
  resource_groups = var.resource_groups
}

module "pip" {
  source     = "./modules/public_ip"
  rg_names   = module.rg.resource_group_names
  public_ips = var.public_ips
  depends_on = [module.rg]
}

module "vnet" {
  source                = "./modules/internal_network_tier"
  networks              = var.networks
  virtual_network_peers = var.virtual_network_peers
  depends_on            = [module.rg]
}

module "vm" {
  source             = "./modules/vm_workload_tier"
  public_ips         = module.pip.ip_ids
  subnet_ids         = module.vnet.subnet_ids
  network_interfaces = var.network_interfaces
  virtual_machines   = var.virtual_machines
  depends_on         = [module.vnet, module.pip]
}

module "auto" {
  source          = "./modules/vm_run_command"
  vm_run_commands = var.vm_run_commands
  vm_ids          = module.vm.vm_ids
  depends_on      = [module.vm]
}

module "lb" {
  source               = "./modules/external_network_tier_lb"
  public_ips           = module.pip.ip_ids
  subnet_ids           = module.vnet.subnet_ids
  bep_nic_ids          = module.vm.nic_ids
  internal_lb          = var.internal_lb
  load_balancers       = var.load_balancers
  lb_probes            = var.lb_probes
  lb_rules             = var.lb_rules
  lb_backend_pools     = var.lb_backend_pools
  nic_bep_associations = var.nic_bep_associations
  depends_on           = [module.vnet, module.pip, module.vm]
}

module "fw" {
  source                                 = "./modules/external_network_tier_fw"
  subnet_ids                             = module.vnet.subnet_ids
  ip_ids                                 = module.pip.ip_ids
  ip_addresses                           = module.pip.ip_addresses
  backend_ip_addresses                   = values(module.lb.private_ip_address) # private ip of load balancer
  firewall_policies                      = var.firewall_policies
  firewall_policy_rule_collection_groups = var.firewall_policy_rule_collection_groups
  firewalls                              = var.firewalls
  route_tables                           = var.route_tables
  subnet_route_table_associations        = var.subnet_route_table_associations
  depends_on                             = [module.vnet, module.pip, module.lb]
}

module "aks" {
  source     = "./modules/aks"
  aks        = var.aks
  subnet_ids = module.vnet.subnet_ids
  depends_on = [module.fw]
}