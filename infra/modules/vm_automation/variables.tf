variable "storage_accounts" {
  description = "The storage account to use for the run command"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  }))
}

variable "storage_containers" {
  description = "The storage container to use for the run command"
  type = map(object({
    name                  = string
    container_access_type = string
  }))
}

variable "vm_ids" {
  description = "map of virtual machine ids from vm_workload_tier"
  type        = map(string)
}

variable "vm_identities" {
  description = "map of virtual machine ids and identities for RBAC"
  type        = map(any)
}

variable "vm_run_commands" {
  description = "map of virtual machine run command"
  type = map(object({
    name               = string
    vm_name            = string
    location           = string
    virtual_machine_id = string # override in main.tf
    source = object({
      script = string
    })
  }))
  default = {}
}

variable "script_name" {
  description = "The name of the script to run"
  type        = string
}