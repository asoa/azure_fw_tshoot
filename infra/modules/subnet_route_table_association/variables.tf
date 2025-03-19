variable "subnet_route_table_associations" {
  type = map(object({
    subnet_name      = string
    route_table_name = string
    subnet_id        = string # override in main
    route_table_id   = string # override in main
  }))
}