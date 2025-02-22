variable "public_ips" {
  description = "map of public IPs"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
    sku                 = string
  }))
}