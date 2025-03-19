# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["jpes"]
}

resource "azurerm_resource_group" "by_map" {
  for_each = var.resource_groups
  name     = "${module.naming.resource_group.name}-${each.value.name}"
  location = each.value.location
}