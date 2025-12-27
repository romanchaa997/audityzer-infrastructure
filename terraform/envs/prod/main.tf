# Production Environment Configuration
module "cloudflare" {
  source = "../../modules/cloudflare"

  zone_id      = var.cloudflare_zone_id
  record_name  = "api"
  record_value = var.lb_ip_address
  ttl          = 1  # Proxied through Cloudflare
  proxied      = true

  cname_records = {
    "app"      = "api.${var.domain}"
    "cdn"      = "api.${var.domain}"
    "api"      = "api.${var.domain}"
  }
}

# Production WAF rules
output "cloudflare_config" {
  value       = module.cloudflare
  description = "Cloudflare configuration for production"
  sensitive   = false
}
