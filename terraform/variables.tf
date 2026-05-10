# ==========================================================
# VARIABLES CONFIGURATION
# FILE: variables.tf
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

# ----------------------------------------------------------
# AWS REGION
# ----------------------------------------------------------

variable "aws_region" {

  description = "AWS region where resources will be deployed"

  type = string

  default = "eu-west-2"
}

# ----------------------------------------------------------
# PROJECT NAME
# ----------------------------------------------------------

variable "project_name" {

  description = "Project name used for resource naming"

  type = string

  default = "github-actions-s3"
}

# ----------------------------------------------------------
# ENVIRONMENT
# ----------------------------------------------------------

variable "environment" {

  description = "Deployment environment"

  type = string

  default = "dev"
}

# ----------------------------------------------------------
# COMMON TAGS
# ----------------------------------------------------------

variable "common_tags" {

  description = "Common tags applied to all resources"

  type = map(string)

  default = {
    Owner       = "Samuel"
    ManagedBy   = "Terraform"
    Automation  = "GitHub-Actions"
    Environment = "dev"
  }
}