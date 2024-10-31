resource "proxmox_virtual_environment_file" "user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_node

  source_file {
    path = var.user_data_file
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
  }

  operating_system {
    type = "l26"
  }

  vga {
    type = "serial0"
  }

  serial_device {}
}