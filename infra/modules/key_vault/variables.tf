variable "key_vaults" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    sku_name                        = string
    enabled_for_deployment          = bool
    enabled_for_disk_encryption     = bool
    enabled_for_template_deployment = bool
    purge_protection_enabled        = bool
    tags                            = map(string)
  }))
}