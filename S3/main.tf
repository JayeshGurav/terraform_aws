terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#Configure the AWS provider
provider "aws" {
region = "ap-south-1"  
}

resource "aws_s3_bucket" "S3-bucket-dev01" {
  bucket = "s3-dev-rgbucket"

  # prevent accidental deletion of this s3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our state file

  versioning {
    enabled = true
  }
# Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-locks-for-s3-bucket"
  billing_mode = "PAY_PER_REQUEST" 
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
}