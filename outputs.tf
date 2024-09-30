output "lb_dns_name" {
   description = "The DNS name of the load balancer"
    value       = "http://${aws_lb.nginx_alb.dns_name}" // retriev load balanc URL
}