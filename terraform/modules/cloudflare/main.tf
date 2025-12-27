# Cloudflare DNS Records Module
resource "cloudflare_record" "app_a_record" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = "A"
  value   = var.record_value
  ttl     = var.ttl
  proxied = var.proxied
}

resource "cloudflare_record" "app_cname" {
  for_each = var.cname_records

  zone_id = var.zone_id
  name    = each.key
  type    = "CNAME"
  value   = each.value
  ttl     = 1  # Proxied
  proxied = true
}

resource "cloudflare_page_rule" "https_enforce" {
  zone_id = var.zone_id
  target  = "${var.record_name}/*"
  priority = 1

  actions {
    always_use_https = "on"
  }
}
