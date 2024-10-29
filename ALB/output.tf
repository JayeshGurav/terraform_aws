output "alb_dns_name" {
    value = aws_lb.LB-SG.dns_name
    description = "Domain name of load balancer"
  
}