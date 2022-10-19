rancher = {
  replicas = 1
  domain = "rancher.go.lab-linux.com"
  version = "2.6.5"
}

cert-manager = {
  enabled = false
}

nodes = {
  masters = {
    count = 1
    cores = 2
    ram_mb = 4096
    storage = "SSD"
    clone = "ubuntu18-template"
    cloud_init_file = "ubuntu18_main.yml"
    name_prefix = "go-rancher"
    bridge = "vmbr1003"
    vlan = 6
    macaddr = [
      "72:EE:7E:4A:56:16",
      # "a6:ab:d8:f1:f5:0a",
      # "fa:b4:d5:a4:a4:bf"
    ]
    roles = [
      "controlplane",
      "worker",
      "etcd"
    ]
    data_disk = [
      {
        mount = "/mnt/etcd"
        storage = "SSD"
        cache = "unsafe"
        size = 200
      }
    ]
  }
}

bastion = {
  host = "bastion.lab-linux.com"
  user = "ubuntu"
  port = 22001
}

proxmox = {
  node_name = "z600"
  insecure = true
  ssh_private_key = "~/.ssh/id_rsa"
  ssh_pub_key = "~/.ssh/id_rsa.pub"
  domain_name = "go"
  use_bastion = true
}

