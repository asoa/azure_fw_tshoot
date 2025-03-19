variable "virtual_network_peers" {
  type = map(object({
    name                        = string
    resource_group_name         = string
    virtual_network_name        = string
    remote_virtual_network_name = string
    remote_virtual_network_id   = string
    allow_forwarded_traffic     = bool
  }))
}