data "netbox_cluster" "vm_cluster" {
  name = var.netbox_cluster
}

data "netbox_tenant" "tenant" {
  name = var.netbox_tenant
}

data "netbox_device_role" "role" {
  name = var.netbox_device_role
}

data "netbox_ip_range" "ip_range" {
  contains = var.ipv4.address
}

resource "netbox_virtual_machine" "vm" {
  cluster_id   = data.netbox_cluster.vm_cluster.id
  name         = var.vm_hostname
  disk_size_gb = var.vm_disk_size
  memory_mb    = var.vm_memory
  vcpus        = var.vm_cpus
  role_id      = data.netbox_device_role.role.id
  tenant_id    = data.netbox_tenant.tenant.id
}

resource "netbox_interface" "vm_eno1" {
  name               = "eno1"
  virtual_machine_id = resource.netbox_virtual_machine.vm.id
}

resource "netbox_available_ip_address" "vm_ip" {
  ip_range_id =  data.netbox_ip_range.ip_range.id
  status       = "active"
  virtual_machine_interface_id = resource.netbox_interface.vm-eno1.id
}