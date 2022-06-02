terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
    rke = {
      source = "rancher/rke"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
  required_version = ">= 0.13"
}
