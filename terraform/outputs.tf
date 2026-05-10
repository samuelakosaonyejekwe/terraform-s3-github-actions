# ==========================================================
# OUTPUT VALUES
# FILE: outputs.tf
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

# ----------------------------------------------------------
# S3 BUCKET NAME
# ----------------------------------------------------------

output "bucket_name" {

  description = "Name of the created S3 bucket"

  value = aws_s3_bucket.github_actions_bucket.bucket
}

# ----------------------------------------------------------
# S3 BUCKET ARN
# ----------------------------------------------------------

output "bucket_arn" {

  description = "ARN of the created S3 bucket"

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

  description = "Regional domain name of the S3 bucket"

  value = aws_s3_bucket.github_actions_bucket.bucket_regional_domain_name
}

# ----------------------------------------------------------
# S3 BUCKET HOSTED ZONE ID
# ----------------------------------------------------------

output "bucket_hosted_zone_id" {

  description = "Hosted zone ID of the S3 bucket"

  value = aws_s3_bucket.github_actions_bucket.hosted_zone_id
}

# ----------------------------------------------------------
# S3 BUCKET REGION
# ----------------------------------------------------------

output "bucket_region" {

  description = "AWS region where the S3 bucket is deployed"

  value = var.aws_region
}