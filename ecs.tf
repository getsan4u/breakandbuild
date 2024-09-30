

resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-cluster"
    
    tags = {
    Name        = "${var.environment}-cluster"
  }
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu           = "256"
  memory        = "512"

  task_role_arn = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_execution_role.arn #corrected typo

  container_definitions = jsonencode([{
    name  = "nginx-container"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
      protocol      = "tcp"
    }]
    essential = true

// Enabled CloudWatch Logs
    logConfiguration = {
     logDriver = "awslogs"
      options = {
       "awslogs-group"         = "/ecs/nginx",
       "awslogs-region"        = "eu-west-2",
       "awslogs-stream-prefix" = "nginx",

   }
    }
  }])

  tags = {
    Name        = "${var.environment}-${var.service}"
    Environment = var.environment
    Service     = var.service
  }

}

resource "aws_ecs_service" "nginx_service" {
  name            = "${var.environment}-${var.service}"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1 # added desired count


  network_configuration {
    subnets         = [aws_subnet.web-1.id, aws_subnet.web-2.id]
    security_groups = [aws_security_group.ecs-sgrp.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
    container_name   = "nginx-container"
    container_port   = 80  #container port is to 80 changed from 81
  }

  depends_on = [
    aws_lb_listener.ngnix_listener, # To avoid ECS service sequenceing issue
    aws_ecs_task_definition.nginx_task
  ]
  tags = {
    Name        = "${var.environment}-${var.service}-ecs-service"
    Environment = var.environment
    Service     = var.service
  }
}

// Enabled CloudWatch Logs 