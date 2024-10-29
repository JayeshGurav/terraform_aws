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

resource "aws_security_group" "instance_sg" {
    name = "terraform-example-instance-sg"  
    
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    }



resource "aws_launch_configuration" "ec21" {
    image_id = "ami-04a37924ffe27da53"
    instance_type = "t2.micro"
    #security_groups = [aws_security_group.instance_sg]

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello World" > index.html
        nohup busybox httpd -f -p ${var.server_port} &
        EOF
  
}

#Now we can create Autoscalling Group

resource "aws_autoscaling_group" "ASG_Premium" {
    launch_configuration = aws_launch_configuration.example.ec21

    min_size = 2
    max_size = 3

    tag {
      key = "ASG_Premium"
      value = "terraform-asg-ASG_Premium"
      propagate_at_launch = true
    }
  
}