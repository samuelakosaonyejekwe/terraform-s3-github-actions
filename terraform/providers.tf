# ==========================================================
# TERRAFORM PROVIDERS CONFIGURATION
# FILE: providers.tf
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

# ----------------------------------------------------------
# AWS PROVIDER
# ----------------------------------------------------------

provider "aws" {

  region = var.aws_region

  default_tags {

    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Samuel-Onyejekwe"
    }
  }
}

# ----------------------------------------------------------
# RANDOM PROVIDER
# ----------------------------------------------------------

provider "random" {}