output "private_ip_address" {
  value = { for k, v in azurerm_lb.lb : k => v.private_ip_address }
}