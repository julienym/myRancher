resource "null_resource" "cloud_init_config_files" {
  count = local.masters.count

  provisioner "file" {
    content =  templatefile("${path.module}/cloud-inits/${local.masters.cloud_init_file}",
      {
        hostname = "${local.masters.name_prefix}${count.index}"
        ssh_pub_key = file(local.proxmox.ssh_pub_key)
        mount = "/var/lib/etcd"
      }
    )
    destination = "${local.proxmox.template_location}/${local.masters.name_prefix}${count.index}"

    connection {
      type     = "ssh"
      user     = local.proxmox_secrets.ssh_user
      private_key = file(local.proxmox.ssh_private_key)
      host     = local.proxmox_secrets.ssh_host
      port     = local.proxmox_secrets.ssh_port
      bastion_host = local.proxmox.use_bastion ? local.bastion.host : null
      bastion_user = local.proxmox.use_bastion ? local.bastion.user : null
      bastion_port = local.proxmox.use_bastion ? local.bastion.port : null
      bastion_private_key = local.proxmox.use_bastion ? file(local.bastion.ssh_private_key) : null
   }
  }

  triggers = {
    fileSHA = sha256(local.cloud_init)
  }
}

module "proxmox_node_rancher" {
  depends_on = [
    null_resource.cloud_init_config_files
  ]
  # source = "git::https://github.com/julienym/myTerraformModules.git//proxmox?ref=1.0.0"
  source = "../myTerraformModules/proxmox"
  count = local.masters.count

  providers = {
    proxmox = proxmox
  }
  name = "${local.masters.name_prefix}${count.index}"
  domain_name = var.proxmox.domain_name
  
  target_node = local.proxmox.node_name
  
  snippet_filename = "${local.masters.name_prefix}${count.index}"
  snippet_sha256 = sha256(local.cloud_init)
  agent = local.masters.agent
  bridge = local.masters.bridge
  vlan = try(local.masters.vlan, null)
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

