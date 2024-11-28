# Proxmox - Netbox - Cloud-init
| A Proxmox terraform module to create cloud-init vm's and add them to Netbox

## Usage

Create a main.tf with the following content:
```HCL
module "proxmox" {
  source = "github.com/lwijnsma/proxmox-netbox-terraform-module"

  vm_cpus = 2
  vm_memory = 2048

  vm_disk_size = 20
  vm_datastore = "local-lvm"
  
  qemu_agent = true

  vm_hostname = "test"
  vm_username = "username"
  sshkeys = ["ssh-ed25519 <SSH_KEY>"]
  
  vm_vlan = "1"
  ipv4 = {
    address = "xx.xx.xx.xx/24"
    gateway = "xx.xx.xx.xx"
  }
}
```

Create a provider.tf with the following:
```HCL
provider "netbox" {
  server_url = "https://demo.netbox.dev"
  api_token  = "<your api key>"
}


provider "proxmox" {
  endpoint = "https://10.0.0.2:8006/"

  username = "username@realm"
  password = "a-strong-password"
  ssh {
    agent       = false
    private_key = file("~/.ssh/id_rsa")
  }
}
```
See [e-breuninger/netbox](https://registry.terraform.io/providers/e-breuninger/netbox/latest/docs) For more info about the netbox provider settings
See [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest/docs) for more info about the proxmox provider settings