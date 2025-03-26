resource "azurerm_kubernetes_cluster" "aks" {
  for_each                         = var.aks
  name                             = each.value.name
  location                         = each.value.location
  resource_group_name              = each.value.resource_group_name
  dns_prefix                       = each.value.dns_prefix
  kubernetes_version               = each.value.kubernetes_version
  local_account_disabled           = each.value.local_account_disabled
  sku_tier                         = each.value.sku_tier
  private_cluster_enabled          = each.value.private_cluster_enabled
  azure_policy_enabled             = each.value.azure_policy_enabled
  http_application_routing_enabled = each.value.http_application_routing_enabled

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = each.value.azure_active_directory_role_based_access_control.azure_rbac_enabled
    admin_group_object_ids = each.value.azure_active_directory_role_based_access_control.admin_group_object_ids
  }
  default_node_pool {
    name                 = each.value.default_node_pool.name
    node_count           = each.value.default_node_pool.node_count
    vm_size              = each.value.default_node_pool.vm_size
    auto_scaling_enabled = each.value.default_node_pool.auto_scaling_enabled
    min_count            = each.value.default_node_pool.min_count
    max_count            = each.value.default_node_pool.max_count
    os_sku               = each.value.default_node_pool.os_sku
    vnet_subnet_id       = var.subnet_ids[each.value.vnet_name][each.value.default_node_pool.vnet_subnet_id]
  }
  network_profile {
    network_plugin      = each.value.network_profile.network_plugin
    network_plugin_mode = each.value.network_profile.network_plugin_mode
    network_policy      = each.value.network_profile.network_policy
    pod_cidr            = each.value.network_profile.pod_cidr
    service_cidr        = each.value.network_profile.service_cidr
    dns_service_ip      = each.value.network_profile.dns_service_ip
    outbound_type       = each.value.network_profile.outbound_type
  }
  identity {
    type = each.value.identity.type
  }
  tags = {
    Environment = each.value.tags.Environment
  }
}