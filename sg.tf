//ECS Security Group

resource "aws_security_group" "ecs-sgrp" {
  name        = "${var.environment}-${var.service}-web-server-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sgrp.id]
    cidr_blocks = ["0.0.0.0/0"] #cidr values for trusted IP is better for security
  }

  egress {
    description = "outbound traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name        = "${var.environment}-${var.service}-ecs-sg"
    Environment = var.environment
    Service     = var.service
    Tier     = "ECS Security Group"
  }
}


resource "aws_security_group" "alb_sgrp" {
  name   = "alb-sg"
  vpc_id = aws_vpc.vpc.id  # Ensure this references your VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere (adjust as necessary)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
    Service     = var.service
  }
}


//RDS Security Group

resource "aws_security_group" "database-sgrp" {
  name        = "${var.environment}-${var.service}-database-sg"
  description = "Allow inbound traffic from application security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow TCP traffic from application layer"
    from_port   = 5032
    to_port     = 5032 
    #Best not to use the default ports any other BD service like MySQL, MSSQL, etc
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] this allows public access
    security_groups = [aws_security_group.ecs-sgrp.id] 
    #Alloq connections from webserver only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name        = "${var.environment}-${var.service}-rds-sg"
    Environment = var.environment
    Service     = var.service
    Tier     = "RDS Security Group"
  }

}
