locals {
  proxmox = merge(var.proxmox_default, var.proxmox)
  proxmox_secrets = merge(var.proxmox_secrets_default, var.proxmox_secrets)
  bastion = merge(var.bastion_default, var.bastion)
  masters = merge(var.nodes_default, var.nodes.masters)
  nodeMap = merge(
  { for index, node in module.proxmox_node_rancher.*.proxmox_nodes: node => {
      vmCode = substr(sha1(module.proxmox_node_rancher[tonumber(index)].proxmox_changeId), 0, 62), #["force_recreate_on_change_of"],
      roles = local.masters.roles }}
  )
  rke_name = "rancher${terraform.workspace == "default" ? "" : "-${terraform.workspace}"}"
  cloud_init = templatefile("${path.module}/cloud-inits/${local.masters.cloud_init_file}",
    {
      hostname = "${local.masters.name_prefix}XXX"
      ssh_pub_key = file(local.proxmox.ssh_pub_key)
      mount = "/var/lib/etcd"
    }
  )
  cloud_init_filename = "rancher-${terraform.workspace}-${local.masters.cloud_init_file}"
}