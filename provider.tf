provider "proxmox" {
  endpoint = "https://proxmox.lab.lwijnsma.nl:8006"
  username = "root@pam"
  password = "Tweaker33#"
}

provider "netbox" {
  server_url = "https://netbox.lab.lwijnsma.nl"
  api_token  = "416c39101c80abc01f7390246a19df77decc88c7"
}