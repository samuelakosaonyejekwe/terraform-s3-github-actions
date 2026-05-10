# ==========================================================
# TERRAFORM BACKEND CONFIGURATION
# FILE: backend.tf
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

terraform {

  backend "s3" {

    # ------------------------------------------------------
    # REMOTE STATE S3 BUCKET
    # ------------------------------------------------------

    bucket = "samuelakosaonyejekwe-tf-state-eu-west-2"

    # ------------------------------------------------------
    # TERRAFORM STATE FILE PATH
    # ------------------------------------------------------

    key = "terraform/s3-github-actions/terraform.tfstate"

    # ------------------------------------------------------
    # AWS REGION
    # ------------------------------------------------------

    region = "eu-west-2"

    # ------------------------------------------------------
    # STATE LOCKING USING DYNAMODB
    # ------------------------------------------------------

    dynamodb_table = "terraform-state-lock"

    # ------------------------------------------------------
    # ENCRYPT TERRAFORM STATE
    # ------------------------------------------------------

    encrypt = true
  }
}