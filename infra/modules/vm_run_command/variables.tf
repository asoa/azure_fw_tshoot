variable "vm_ids" {
  description = "map of virtual machine ids from vm module"
  type        = map(string)
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
}