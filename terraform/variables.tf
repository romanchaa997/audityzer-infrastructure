variable "environment" {
  type        = string
  description = "Environment name (dev, stage, prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "kubernetes_host" {
  type        = string
  description = "Kubernetes cluster endpoint"
  sensitive   = true
}

variable "kubernetes_cluster_ca_certificate" {
  type        = string
  description = "Kubernetes cluster CA certificate"
  sensitive   = true
}

variable "kubernetes_token" {
  type        = string
  description = "Kubernetes auth token"
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID for domain"
}
