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

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type = number   
    default = 8080  
}

# To use the value from an input variable in your Terraform code, you can use a new type of expression called a variable reference, which has the following syntax:

# var.<variable_name>

# For example . here is how yopu can set the from_port and to_port parameters of the secrity group to the value of the server_port vaible

resource "aws_security_group" "instance_sg" {
    name = "terraform-example-instance-sg"  
    
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    }