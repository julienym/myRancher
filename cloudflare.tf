resource "cloudflare_record" "rancher" {
  zone_id = var.cloudflare.zone_id
  name    = "rancher"
  value   = var.cloudflare.ip
  type    = "A"
  ttl     = 1
  proxied = true
}
