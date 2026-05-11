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
# RANDOM STRING FOR JENKINS PIPELINE BUCKET
# ----------------------------------------------------------

resource "random_id" "jenkins_bucket_suffix" {
  byte_length = 4
}

# ----------------------------------------------------------
# ORIGINAL S3 BUCKET
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
# JENKINS PIPELINE S3 BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket" "jenkins_pipeline_bucket" {

  bucket = "samuel-jenkins-pipeline-${random_id.jenkins_bucket_suffix.hex}"

  tags = {
    Name        = "jenkins-pipeline-bucket"
    Environment = var.environment
    ManagedBy   = "Jenkins"
    Project     = "terraform-jenkins-pipeline"
  }
}

# ----------------------------------------------------------
# VERSIONING - ORIGINAL BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ----------------------------------------------------------
# VERSIONING - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_versioning" "jenkins_versioning" {

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ----------------------------------------------------------
# SERVER-SIDE ENCRYPTION - ORIGINAL BUCKET
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
# SERVER-SIDE ENCRYPTION - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "jenkins_encryption" {

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id

  rule {

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------------------------------------------
# BLOCK PUBLIC ACCESS - ORIGINAL BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "public_access_block" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ----------------------------------------------------------
# BLOCK PUBLIC ACCESS - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "jenkins_public_access_block" {

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ----------------------------------------------------------
# OWNERSHIP CONTROLS - ORIGINAL BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_ownership_controls" "ownership" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ----------------------------------------------------------
# OWNERSHIP CONTROLS - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_ownership_controls" "jenkins_ownership" {

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ----------------------------------------------------------
# ACL - ORIGINAL BUCKET
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
# ACL - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_acl" "jenkins_bucket_acl" {

  depends_on = [
    aws_s3_bucket_ownership_controls.jenkins_ownership,
    aws_s3_bucket_public_access_block.jenkins_public_access_block
  ]

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id
  acl    = "private"
}

# ----------------------------------------------------------
# LIFECYCLE CONFIGURATION - ORIGINAL BUCKET
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
# LIFECYCLE CONFIGURATION - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_lifecycle_configuration" "jenkins_lifecycle" {

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id

  rule {

    id     = "jenkins-lifecycle-rule"
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
# BUCKET LOGGING - ORIGINAL BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_logging" "logging" {

  bucket = aws_s3_bucket.github_actions_bucket.id

  target_bucket = aws_s3_bucket.github_actions_bucket.id
  target_prefix = "logs/"
}

# ----------------------------------------------------------
# BUCKET LOGGING - JENKINS BUCKET
# ----------------------------------------------------------

resource "aws_s3_bucket_logging" "jenkins_logging" {

  bucket = aws_s3_bucket.jenkins_pipeline_bucket.id

  target_bucket = aws_s3_bucket.jenkins_pipeline_bucket.id
  target_prefix = "logs/"
}