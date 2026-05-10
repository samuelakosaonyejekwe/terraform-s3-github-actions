#!/bin/bash

# ==========================================================
# SCRIPT: destroy.sh
# PURPOSE: Destroy Terraform Infrastructure
# PROJECT: S3 Bucket with GitHub Actions Automation
# ==========================================================

set -e

echo "=================================================="
echo " TERRAFORM DESTROY STARTED "
echo "=================================================="

# ----------------------------------------------------------
# MOVE INTO TERRAFORM DIRECTORY
# ----------------------------------------------------------

cd "$(dirname "$0")/../terraform"

# ----------------------------------------------------------
# INITIALIZE TERRAFORM
# ----------------------------------------------------------

echo "Initializing Terraform..."

terraform init

# ----------------------------------------------------------
# VALIDATE CONFIGURATION
# ----------------------------------------------------------

echo "Validating Terraform configuration..."

terraform validate

# ----------------------------------------------------------
# DESTROY INFRASTRUCTURE
# ----------------------------------------------------------

echo "Destroying infrastructure..."

terraform destroy -auto-approve

# ----------------------------------------------------------
# COMPLETION MESSAGE
# ----------------------------------------------------------

echo "=================================================="
echo " TERRAFORM DESTROY COMPLETED SUCCESSFULLY "
echo "=================================================="