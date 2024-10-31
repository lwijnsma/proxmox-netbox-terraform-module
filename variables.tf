variable "pve_node" {
  type = string
  default = "pve"
}
variable "qemu_agent"{
  type = bool
  default = true
}
variable "vm_hostname" {
  type = string
}
variable "vm_username" {
  type = string  
}
variable "vm_tags" {
  type = list(string)
  default = ["terraform"]  
}
variable "vm_bridge" {
  type = string
  default = "vmbr0"
}
variable "vm_datastore" {
  type = string
  default = "local-lvm"
}
variable "vm_disk_size" {
  type = number
  default = 20
}
variable "user_data_file" {
  type = string
  default = "cloud-init/user-data.yaml"
  
}
variable "vm_memory" {
  type = number
  default = 2048
}
variable "vm_cpus" {
  type = number
  default = 2
}
variable "vm_description" {
  type = string
  default = "Managed by Terraform"
}
variable "netbox_cluster" {
  type = string
  default = "Proxmox"
}
variable "netbox_tenant" {
  type = string
}
variable "netbox_device_role" {
  type = string
  default = "Application-server"
}
variable "sshkeys" {
  type = list(string)
  default = null
}
variable "cloud_image_url" {
  type = string
}
variable "ipv4" {
  type = object({
    address = string
    gateway = optional(string)
  })
  default = {
    address = "dhcp"
  }
}
