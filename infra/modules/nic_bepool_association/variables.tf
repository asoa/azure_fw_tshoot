variable "nic_bepool_associations" {
  description = "map of NIC backend address pool associations"
  type = map(object({
    network_interface_id    = string
    ip_configuration_name   = string
    backend_address_pool_id = string
    backend_pool_key        = string
  }))
}