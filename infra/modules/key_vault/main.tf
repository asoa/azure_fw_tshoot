data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "by_map" {
  for_each                        = var.key_vaults
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = each.value.sku_name
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  purge_protection_enabled        = each.value.purge_protection_enabled
  tags                            = each.value.tags
}