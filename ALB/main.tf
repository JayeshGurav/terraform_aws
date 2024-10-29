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

# AWS offers 3types of Load Balancer

# Application Load balancer (ALB): Best suited for load balancing of http and https traffic. Operates at the application layer (Layer7) of the OSI model.check 

# Network Load balancer (NLB): Best suited for laod balncing of TCP, UDP and TLS traffic. Can scale up and down in responce to load faster than the ALB (The NLB is designed to scale to tens of millions of request per second).
# Operates at the transport layer (Layer4) of the OSI Model. 

# Classic Load balancer (CLB): This is the "legacy" load balancer that preadates both the ALB and NLB. It can handle HTTP, HTTPS, TCP, UDP and TLS traffic, but with far fewer features than either the ALB or NLB. 
# Operates at both the application layer (L7) and Transport layer (L4). 
variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type = number   
    default = 8080  
}

resource "aws_lb" "ALB" {
    name = "Terraform-asg"
    load_balancer_type = "application"
    subnets = data.aws_subnets_ids.default.ids
  
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = "aws_lb.example.arn"
    port = 80
    protocol = "HTTP"

    #by default, return a simple 404 page. 

    default_action {
      type = "fixed-responce"
      
      fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code = 404
      }
    }
  
}

resource "aws_security_group" "ASG_ALB" {
    name = "terraform-alb-asg"

    #allow inbound HTTP requests

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  

    #allow all outbound requests

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "LB-SG" {
    name = "terraform-lb-asg"
    load_balancer_type = "application"
    subnets = data.aws_subnets_ids.default.ids
    security_groups = [aws_security_group.ASG_ALB.id]

}

resource "aws_lb_target_group" "asg-target-group" {
    name = "terraform-lb-target-group"
    port = var.server_port
    protocol = "HTTP"
    #vcp_id = data.aws_vpc.default.id
    
    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

