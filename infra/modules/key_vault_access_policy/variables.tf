variable "key_vault_access_policies" {
  description = "Map of key vault access policies"
  type = map(object({
    key_vault_id            = string
    tenant_id               = string
    object_id               = string
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))
}