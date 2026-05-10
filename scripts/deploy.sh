#!/bin/bash

# ==========================================================
# SCRIPT: deploy.sh
# PURPOSE: Deploy Terraform Infrastructure
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

set -e

echo "=========================================="
echo "Initializing Terraform..."
echo "=========================================="

cd terraform

terraform init

echo "=========================================="
echo "Formatting Terraform Files..."
echo "=========================================="

terraform fmt -recursive

echo "=========================================="
echo "Validating Terraform Configuration..."
echo "=========================================="

terraform validate

echo "=========================================="
echo "Generating Terraform Plan..."
echo "=========================================="

terraform plan -out=tfplan

echo "=========================================="
echo "Applying Terraform Infrastructure..."
echo "=========================================="

terraform apply -auto-approve tfplan

echo "=========================================="
echo "Terraform Deployment Completed Successfully"
echo "=========================================="