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
  description = var.ip_range
}

resource "netbox_virtual_machine" "myvm" {
  cluster_id   = data.netbox_cluster.vm_cluster.id
  name         = var.vm_hostname
  memory_mb    = var.vm_memory
  vcpus        = var.vm_cpus
  role_id      = data.netbox_device_role.role.id
  tenant_id    = data.netbox_tenant.tenant.id
}

resource "netbox_virtual_disk" "scsi0" {
  name               = "scsi0"
  description        = "Main disk"
  size_mb            = var.vm_disk_size * 1024
  virtual_machine_id = netbox_virtual_machine.myvm.id
}

resource "netbox_interface" "myvm-eno1" {
  name               = "eno1"
  virtual_machine_id = resource.netbox_virtual_machine.myvm.id
}

resource "netbox_available_ip_address" "vm_ip" {
  ip_range_id =  data.netbox_ip_range.ip_range.id
  status       = "active"
  virtual_machine_interface_id = resource.netbox_interface.myvm-eno1.id
}

resource "proxmox_virtual_environment_file" "user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_node

  source_raw {
    data = templatefile("${path.module}/cloud-init/user-data.tftpl", {
      qemu_agent = var.qemu_agent,
      vm_hostname = var.vm_hostname,
      vm_username = var.vm_username,
      sshkeys = var.sshkeys
    })
    file_name = "cloud-config-user-data-${var.vm_hostname}.yaml"
  }

}

resource "proxmox_virtual_environment_file" "meta_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_node

  source_raw {
      data =  <<EOF
local-hostname: ${var.vm_hostname}
EOF

      file_name = "cloud-config-meta-data-${var.vm_hostname}.yaml"
  }
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.pve_node
  url          = var.cloud_image_url
}

resource "proxmox_virtual_environment_vm" "myvm" {
  name        = var.vm_hostname
  description = var.vm_description
  tags        = var.vm_tags
  node_name = var.pve_node

  cpu {
    cores = var.vm_cpus
  }

  memory {
    dedicated = var.vm_memory
  }

  agent {
    enabled = var.qemu_agent
  }

  disk {
    datastore_id = var.vm_datastore
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
    interface    = "virtio0"
    iothread     = true
    size         = var.vm_disk_size
  }

  initialization {
    ip_config {
        ipv4 {
          address = resource.netbox_available_ip_address.vm_ip.ip_address
          gateway = var.ipv4.gateway
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.user_data.id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data.id
  }

  network_device {
    bridge = var.vm_bridge
    vlan_id = var.vm_vlan_id

  }

  operating_system {
    type = "l26"
  }

  vga {
    type = "serial0"
  }

  serial_device {}
}
