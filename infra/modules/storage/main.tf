resource "azurerm_storage_account" "sa" {
  for_each                      = var.storage_accounts
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  account_tier                  = each.value.account_tier
  account_replication_type      = each.value.account_replication_type
  public_network_access_enabled = each.value.public_network_access_enabled
  network_rules {
    default_action             = each.value.network_rules.default_action
    ip_rules                   = each.value.network_rules.ip_rules
    virtual_network_subnet_ids = var.subnet_ids
  }
  tags = each.value.tags
}

resource "azurerm_storage_container" "sc" {
  for_each              = var.storage_containers
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.sa[each.value.storage_account_id].id
  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_share" "ss" {
  for_each           = var.storage_shares
  name               = each.value.name
  storage_account_id = azurerm_storage_account.sa[each.value.storage_account_id].id
  quota              = each.value.quota
}