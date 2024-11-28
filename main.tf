terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.68.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "3.9.2"
    }
  }
}