terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.66.3"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "3.9.2"
    }
  }
}