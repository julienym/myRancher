module "rke" {
  # source = "git::https://github.com/julienym/myTerraformModules.git//rke?ref=1.0.0"
  source = "../myTerraformModules/rke"

  name = local.rke_name
  api_domain = var.rancher.domain
  domain_name = var.proxmox.domain_name

  nodes = local.nodeMap
  bastion = local.bastion
  kubeconfig_path = "${pathexpand("~/.kube/clusters")}/${local.rke_name}"
}