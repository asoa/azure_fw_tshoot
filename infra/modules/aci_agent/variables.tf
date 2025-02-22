variable "azure_devops_org_name" {
  description = "The name of the Azure DevOps organization"
  type        = string
}

variable "azure_devops_personal_access_token" {
  description = "The personal access token for Azure DevOps"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "agent_resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "linux_agents_configuration" {
  description = "Configuration for Linux agents"
  type = object({
    agent_name_prefix            = string
    agent_pool_name              = string
    count                        = number
    docker_image                 = string
    docker_tag                   = string
    cpu                          = number
    memory                       = number
    user_assigned_identity_ids   = list(string)
    use_system_assigned_identity = bool
  })
}

variable "image_registry_credential" {
  description = "The credentials for the image registry"
  type = object({
    username = string
    password = string
    server   = string
  })
}