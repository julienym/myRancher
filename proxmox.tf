resource "null_resource" "cloud_init_config_files" {
  provisioner "file" {
    content = templatefile("${path.module}/cloud-inits/${local.masters.cloud_init_file}",
      {
        ssh_pub_key = file(local.proxmox.ssh_pub_key)
        mount = "/var/lib/etcd"
      }
    )
    destination = "${local.proxmox.template_location}/${local.masters.cloud_init_file}"

    connection {
      type     = "ssh"
      user     = local.proxmox_secrets.ssh_user
      private_key = file(local.proxmox.ssh_private_key)
      host     = local.proxmox_secrets.ssh_host
      port     = local.proxmox_secrets.ssh_port
      bastion_host = local.bastion.host != "" ? local.bastion.host : ""
      bastion_user = local.bastion.host != "" ? local.bastion.user : ""
      bastion_port = local.bastion.host != "" ? local.bastion.port : 22
      bastion_private_key = local.bastion.host != "" ? file(local.bastion.ssh_private_key) : ""
   }
  }

  triggers = {
    fileSHA = sha256(file("${path.module}/cloud-inits/${local.masters.cloud_init_file}"))
  }
}

module "proxmox_node_rancher" {
  depends_on = [
    null_resource.cloud_init_config_files
  ]
  source = "git::https://github.com/julienym/myTerraformModules.git//proxmox?ref=1.0.0"
  count = local.masters.count

  providers = {
    proxmox = proxmox
  }
  name = "${local.masters.name_prefix}${count.index}"
  domain_name = var.proxmox.domain_name
  
  target_node = local.proxmox.node_name
  snippet = "${path.module}/cloud-inits/${local.masters.cloud_init_file}"
  agent = local.masters.agent
  bridge = local.masters.bridge
  clone = local.masters.clone
  disk_gb = local.masters.disk_gb
  ram_mb = local.masters.ram_mb
  cores = local.masters.cores
  storage = local.masters.storage
  onboot = local.masters.onboot
  macaddr = local.masters.macaddr[count.index]
  bastion = local.bastion
  data_disk = local.masters.data_disk
}

