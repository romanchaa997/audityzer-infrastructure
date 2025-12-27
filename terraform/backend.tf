terraform {
  backend "s3" {
    # Configure these via backend config file or -backend-config CLI flags
    # bucket         = "audityzer-tf-state-prod"
    # key            = "prod/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}

# Alternative: Use Terraform Cloud
# terraform {
#   cloud {
#     organization = "your-org"
#     workspaces {
#       name = "audityzer-prod"
#     }
#   }
# }
