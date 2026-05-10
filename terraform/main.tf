# ==========================================================
# TERRAFORM CONFIGURATION
# FILE: main.tf
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

# ----------------------------------------------------------
# RANDOM STRING FOR UNIQUE BUCKET NAME
# ----------------------------------------------------------

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ----------------------------------------------------------
# S3 BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket" "github_actions_bucket" {

  bucket = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

# ----------------------------------------------------------
# S3 BUCKET VERSIONING
# ----------------------------------------------------------

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ----------------------------------------------------------
# SERVER-SIDE ENCRYPTION
# ----------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  rule {

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------------------------------------------
# BLOCK PUBLIC ACCESS
# ----------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "public_access_block" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ----------------------------------------------------------
# S3 BUCKET OWNERSHIP CONTROLS
# ----------------------------------------------------------

resource "aws_s3_bucket_ownership_controls" "ownership" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ----------------------------------------------------------
# S3 BUCKET ACL
# ----------------------------------------------------------

resource "aws_s3_bucket_acl" "bucket_acl" {

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.public_access_block
  ]

  bucket = aws_s3_bucket.github_actions_bucket.id
  acl    = "private"
}

# ----------------------------------------------------------
# OPTIONAL: LIFECYCLE CONFIGURATION
# ----------------------------------------------------------

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  rule {

    id     = "log-lifecycle-rule"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# ----------------------------------------------------------
# OPTIONAL: BUCKET LOGGING
# ----------------------------------------------------------

resource "aws_s3_bucket_logging" "logging" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  target_bucket = aws_s3_bucket.github_actions_bucket.id
  target_prefix = "logs/"
}