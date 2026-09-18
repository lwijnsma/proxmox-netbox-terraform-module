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
variable "vm_memory" {
  type = number
  default = 2048
}
variable "vm_cpus" {
  type = number
  default = 2
}
variable "vm_vlan_id" {
  type = number
  default = 1610
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
  default = "application-server"
}
variable "sshkeys" {
  type = list(string)
  default = null
}
variable "cloud_image_url" {
  type = string
  default = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
}
variable "ip_range" {
  type = string
  default = "VM's"
}
