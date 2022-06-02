provider "proxmox" {
    pm_api_url = local.proxmox_secrets.url
    pm_user = local.proxmox_secrets.user
    pm_password = local.proxmox_secrets.pass
    pm_tls_insecure = local.proxmox.insecure
    pm_log_enable = local.proxmox.debug
    pm_log_file = local.proxmox.debug ? "terraform-plugin-proxmox.log" : ""
    pm_log_levels = local.proxmox.debug ? {
        _default = "info"
        _capturelog = ""
    } : {}
}

provider "rke" {
  debug = false
#   log_file = "<RKE_LOG_FILE>"
}

provider "helm" {
  kubernetes {
    host     = "https://${var.rancher.domain}:6443"

    client_certificate     = module.rke.client_cert 
    client_key             = module.rke.client_key 
    cluster_ca_certificate = module.rke.ca_crt 
  }
}

provider "kubectl" {
  host     = "https://${var.rancher.domain}:6443"

  client_certificate     = module.rke.client_cert 
  client_key             = module.rke.client_key 
  cluster_ca_certificate = module.rke.ca_crt 
  load_config_file       = false
}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://${var.rancher.domain}"
  bootstrap = true
}

provider "cloudflare" {
  email   = var.cloudflare.email
  api_token = var.cloudflare.api_token
}