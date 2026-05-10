# ==========================================================
# TERRAFORM OUTPUTS
# FILE: modules/s3_bucket/outputs.tf
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

# ----------------------------------------------------------
# S3 BUCKET NAME
# ----------------------------------------------------------

output "bucket_name" {

  description = "Name of the S3 bucket"

  value = aws_s3_bucket.github_actions_bucket.bucket
}

# ----------------------------------------------------------
# S3 BUCKET ARN
# ----------------------------------------------------------

output "bucket_arn" {

  description = "ARN of the S3 bucket"

  value = aws_s3_bucket.github_actions_bucket.arn
}

# ----------------------------------------------------------
# S3 BUCKET DOMAIN NAME
# ----------------------------------------------------------

output "bucket_domain_name" {

  description = "Bucket domain name"

  value = aws_s3_bucket.github_actions_bucket.bucket_domain_name
}

# ----------------------------------------------------------
# S3 BUCKET REGIONAL DOMAIN NAME
# ----------------------------------------------------------

output "bucket_regional_domain_name" {

  description = "Regional domain name of the bucket"

  value = aws_s3_bucket.github_actions_bucket.bucket_regional_domain_name
}

# ----------------------------------------------------------
# S3 BUCKET ID
# ----------------------------------------------------------

output "bucket_id" {

  description = "ID of the S3 bucket"

  value = aws_s3_bucket.github_actions_bucket.id
}