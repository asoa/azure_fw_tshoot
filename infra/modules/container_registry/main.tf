resource "azurerm_container_registry" "azcr" {
  name                = var.azcr.name
  resource_group_name = var.azcr.resource_group_name
  location            = var.azcr.location
  sku                 = var.azcr.sku
  admin_enabled       = var.azcr.admin_enabled
}