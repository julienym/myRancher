
rke_name = "rancher"

rancher = {
  replicas = 3
  domain = "rancher.lab-linux.com"

}

nodes = {
  masters = {
    count = 3
    cores = 2
    ram_mb = 4069
    storage = "SSD"
    clone = "ubuntu18-template"
    cloud_init_file = "ubuntu18_main.yml"
    name_prefix = "rancher"
    bridge = "vmbr0"
    macaddr = [
      "0e:87:80:89:2b:29",
      "a6:ab:d8:f1:f5:0a",
      "fa:b4:d5:a4:a4:bf"
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

bastion = {}

proxmox = {
  node_name = "z600"
  insecure = true
  ssh_private_key = "~/.ssh/id_rsa"
  ssh_pub_key = "~/.ssh/id_rsa.pub"
  domain_name = "vm"
}

