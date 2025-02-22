# https://github.com/Azure/terraform-azurerm-aci-devops-agent

module "aci-devops-agent" {
  source                             = "Azure/aci-devops-agent/azurerm"
  version                            = "0.9.4"
  resource_group_name                = var.agent_resource_group_name
  location                           = var.location
  enable_vnet_integration            = false
  create_resource_group              = false
  linux_agents_configuration         = var.linux_agents_configuration
  azure_devops_org_name              = var.azure_devops_org_name
  azure_devops_personal_access_token = var.azure_devops_personal_access_token
  image_registry_credential          = var.image_registry_credential
}