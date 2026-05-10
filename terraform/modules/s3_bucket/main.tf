# ==========================================================
# TERRAFORM MODULE
# FILE: modules/s3_bucket/main.tf
# PURPOSE: REUSABLE PRODUCTION-GRADE S3 BUCKET MODULE
# ==========================================================

# ----------------------------------------------------------
# RANDOM SUFFIX FOR GLOBAL UNIQUENESS
# ----------------------------------------------------------

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ----------------------------------------------------------
# S3 BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket" "this" {

  bucket = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-bucket"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# ----------------------------------------------------------
# VERSIONING
# ----------------------------------------------------------

resource "aws_s3_bucket_versioning" "this" {

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# ----------------------------------------------------------
# SERVER-SIDE ENCRYPTION
# ----------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------------------------------------------
# BLOCK PUBLIC ACCESS
# ----------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "this" {

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ----------------------------------------------------------
# OWNERSHIP CONTROLS
# ----------------------------------------------------------

resource "aws_s3_bucket_ownership_controls" "this" {

  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ----------------------------------------------------------
# PRIVATE ACL
# ----------------------------------------------------------

resource "aws_s3_bucket_acl" "this" {

  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this
  ]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

# ----------------------------------------------------------
# LIFECYCLE POLICY
# ----------------------------------------------------------

resource "aws_s3_bucket_lifecycle_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {

    id     = "standard-lifecycle-policy"
    status = "Enabled"

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
# ACCESS LOGGING
# ----------------------------------------------------------

resource "aws_s3_bucket_logging" "this" {

  bucket = aws_s3_bucket.this.id

  target_bucket = aws_s3_bucket.this.id
  target_prefix = "logs/"
}