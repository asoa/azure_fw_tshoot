# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["jpes"]
}

resource "azurerm_public_ip" "by_map" {
  for_each            = var.public_ips
  name                = "${module.naming.public_ip.name}-${each.key}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku # need standard for load balancer
}