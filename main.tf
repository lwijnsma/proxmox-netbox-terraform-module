terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.113.1s"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "5.8.0"
    }
  }
}
