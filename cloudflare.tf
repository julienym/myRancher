resource "cloudflare_record" "rancher" {
  zone_id = var.cloudflare.zone_id
  name    = join(".", slice(split(".", var.rancher.domain),0,length(split(".", var.rancher.domain))-2))
  value   = var.cloudflare.ip
  type    = "A"
  ttl     = var.cloudflare.proxied ? 1 : 300
  proxied = var.cloudflare.proxied
}
