variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "record_name" {
  type        = string
  description = "DNS record name"
}

variable "record_value" {
  type        = string
  description = "DNS record IP address"
}

variable "cname_records" {
  type        = map(string)
  description = "CNAME records to create"
  default     = {}
}

variable "ttl" {
  type        = number
  description = "TTL for DNS records"
  default     = 3600
}

variable "proxied" {
  type        = bool
  description = "Whether record is proxied through Cloudflare"
  default     = true
}
