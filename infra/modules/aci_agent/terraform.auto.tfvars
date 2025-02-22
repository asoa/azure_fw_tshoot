azure_devops_org_name              = "<YOUR_ORG_NAME>"
azure_devops_personal_access_token = "<YOUR_PERSONAL_ACCESS_TOKEN>"
location                           = "East US 2"
agent_resource_group_name          = "<YOUR_RESOURCE_GROUP_NAME>"
linux_agents_configuration = {
  agent_name_prefix            = "linux-agent"
  agent_pool_name              = "<YOUR_AGENT_POOL_NAME>"
  count                        = 2
  docker_image                 = "<YOU_DOCKER_IMAGE>"
  docker_tag                   = "<YOUR_DOCKER_TAG>"
  cpu                          = 1
  memory                       = 4
  user_assigned_identity_ids   = []
  use_system_assigned_identity = false
}
image_registry_credential = {
  username = "<YOUR_USERNAME>"
  server   = "<ACR login server>"
}