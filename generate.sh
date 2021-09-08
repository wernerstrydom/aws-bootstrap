#!/bin/bash

cat > backend.tf << EOL
terraform {
  backend "s3" {
    bucket         = "${TF_BACKEND_S3_BUCKET}"
    key            = "aws/v1.0.0/terraform.tfstate"
    region         = "${TF_BACKEND_S3_REGION}"
    dynamodb_table = "${TF_BACKEND_S3_DYNAMODB_TABLE}"
    encrypt        = true
  }
}
EOL