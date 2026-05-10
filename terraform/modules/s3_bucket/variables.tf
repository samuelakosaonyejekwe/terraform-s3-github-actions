# ==========================================================
# TERRAFORM VARIABLES
# FILE: modules/s3_bucket/variables.tf
# MODULE: S3 BUCKET
# ==========================================================

# ----------------------------------------------------------
# PROJECT NAME
# ----------------------------------------------------------

variable "project_name" {

  description = "Name of the project"

  type = string
}

# ----------------------------------------------------------
# ENVIRONMENT
# ----------------------------------------------------------

variable "environment" {

  description = "Deployment environment"

  type = string
}

# ----------------------------------------------------------
# AWS REGION
# ----------------------------------------------------------

variable "aws_region" {

  description = "AWS region for resource deployment"

  type = string
}

# ----------------------------------------------------------
# BUCKET VERSIONING
# ----------------------------------------------------------

variable "enable_versioning" {

  description = "Enable or disable S3 bucket versioning"

  type    = bool
  default = true
}

# ----------------------------------------------------------
# SERVER SIDE ENCRYPTION
# ----------------------------------------------------------

variable "enable_encryption" {

  description = "Enable server-side encryption"

  type    = bool
  default = true
}

# ----------------------------------------------------------
# LIFECYCLE CONFIGURATION
# ----------------------------------------------------------

variable "enable_lifecycle_rules" {

  description = "Enable lifecycle management rules"

  type    = bool
  default = true
}

# ----------------------------------------------------------
# RESOURCE TAGS
# ----------------------------------------------------------

variable "tags" {

  description = "Common resource tags"

  type        = map(string)

  default = {
    ManagedBy = "Terraform"
  }
}