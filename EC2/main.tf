terraform {
  required_providers {
    aws = {
      source = "hasicorp/aws"
      version = "~> 5.0"
    }
  }
}

#Configure the AWS provider
provider "aws" {
region = "ap-south-1"  
}

#EC2 instance with count
resource "aws_instance" "terraform_instance" {
  count = 2 #create 2 similar instance

  ami = "ami-0d081196e3df05f4d"
  instancce_type = "t2.micro"

  tags = {
    Name = "ec2 ($count.index)"
  }
  
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]

}

resource "aws_network_interface" "terraform_nic" {
  subnet_id = var.subnet_id   
}

resource "aws_instance" "server" {
  count = 1
  ami = data.aws_ami.amazonlinux.id 
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = {
      network_interface_id = aws_network_interface.terraform_nic.id
      device_index = 0 
    }
  }
  
}