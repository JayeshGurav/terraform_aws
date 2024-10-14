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

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}