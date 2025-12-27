# Development Environment Configuration
module "cloudflare" {
  source = "../../modules/cloudflare"

  zone_id      = var.cloudflare_zone_id
  record_name  = "api-dev"
  record_value = var.lb_ip_address
  ttl          = 3600
  proxied      = true

  cname_records = {
    "app-dev"  = "api-dev.${var.domain}"
    "cdn-dev"  = "api-dev.${var.domain}"
  }
}

# Development-specific outputs
output "cloudflare_nameservers" {
  value       = module.cloudflare
  description = "Cloudflare configuration for development"
}
