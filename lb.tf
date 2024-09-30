resource "aws_lb" "nginx_alb" {
  name               = "${var.environment}-tg"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  security_groups    = [aws_security_group.alb_sgrp.id]

  enable_deletion_protection = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.environment}-alb" #fixed variable Issue
    Environment = var.environment
    Service     = var.service
  }
}


resource "aws_lb_target_group" "nginx_target_group" {
  name     = "${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"

    health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

 tags = {
    Name        = "${var.environment}-tg"
    Environment = var.environment
    Service     = var.service
  }
}

resource "aws_lb_listener" "ngnix_listener" { 
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
//Added tags debug , improves traceability and helps with cost optimisation
  tags = {
    Name        = "${var.environment}-listener"
    Environment = var.environment
    Service     = var.service
  }

  
}

//caused validation error to added load_balancer block under ECS resource
//resource "aws_lb_target_group_attachment" "nginx_target_group_attachment" {
//  target_group_arn = aws_lb_target_group.nginx_target_group.arn
//  target_id        = aws_ecs_service.nginx_service.name
//}

//Eliminating Duplication: Reduces the complexity and potential for errors.


