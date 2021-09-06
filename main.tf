provider "aws" {
    version = "~> 2.0"
    region = "us-east-1"
}

resource "aws_iam_user" "main" {
    name = "DeploymentService"
    path = "/"
}

resource "aws_iam_access_key" "main" {
  user = aws_iam_user.main.name
}

resource "aws_iam_group" "main" {
    name = "DeploymentServices"
    path = "/"
}

resource "aws_iam_group_membership" "main" {
    name  = "DeploymentServicesGroupMembership"
    users = [
        aws_iam_user.main.name,
    ]
    group = aws_iam_group.main.name
}

resource "aws_iam_policy" "main" {
    name        = "DeploymentServicesFullAccess"
    path        = "/"
    description = "Allows services full access to bootstrap environments"
    policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "main" {
  bucket = "wernerstrydom-deployment"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "main" {
  name = "wernerstrydom-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


resource "aws_iam_policy_attachment" "main" {
    name       = "DeploymentServicesFullAccessPolicyAttachment"
    policy_arn = aws_iam_policy.main.arn
    groups     = [
       aws_iam_group.main.name
    ]
    users      = []
    roles      = []
}

output "aws_access_key_id" {
  value = aws_iam_access_key.main.id
}

output "aws_access_key_secret" {
  value = aws_iam_access_key.main.secret
}

output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.main.arn
  description = "The arn of the S3 bucket where terraform state is stored"
}

output "aws_dynamodb_table_name" {
  value = aws_dynamodb_table.main.name
  description = "The name of the DynamoDB table"
}
