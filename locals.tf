locals {
  proxmox = merge(var.proxmox_default, var.proxmox)
  proxmox_secrets = merge(var.proxmox_secrets_default, var.proxmox_secrets)
  bastion = var.bastion_default #merge(var.bastion_default, var.bastion)
  masters = merge(var.nodes_default, var.nodes.masters)
  nodeMap = merge(
  { for index, node in module.proxmox_node_rancher.*.proxmox_nodes: nonsensitive(node) => {
      vmCode = substr(sha1(module.proxmox_node_rancher[tonumber(index)].proxmox_changeId), 0, 62), #["force_recreate_on_change_of"],
      roles = local.masters.roles }}
  )
  rke_name = "${var.rke_name}${terraform.workspace == "default" ? "" : "-${terraform.workspace}"}"
}