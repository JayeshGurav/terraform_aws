terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

#Configure the Aws Provider
provider "aws" {
    region = "ap-south-1"
}

# Create a VPC
resource "aws_vpc" "terraform_VPC" {
    cidr_block = "10.0.0.0/16"  
}

resource "aws_subnet" "terraform_subnet" {
    vpc_id = aws_vpc.terraform_VPC.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.0.0/24"

    tags = {
        Name = "tf-vpcAndSubnet"
    }
}