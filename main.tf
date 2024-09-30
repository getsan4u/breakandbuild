
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0" # Use semantic versioning for better version control
    }
  }


//It is a Best practice to store the state file in remote location s3 or terraform cloud
// backend "s3" {
//    bucket         = "my-terraform-state-bucket"   
//    key            = "path/to/my/terraform.tfstate" 
//    region         = "eu-west-2"
//    encrypt        = true                          
//    dynamodb_table = "terraform-locks" 
//  }
}


provider "aws" {
  region     = "eu-west-2"  
}


//IAM Roles and policy

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-${var.service}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }] 
  })
 tags = {
    Name        = "${var.environment}-${var.service}-ecs-task-role"
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}-${var.service}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
  tags = {
    Name        = "${var.environment}-${var.service}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

resource "aws_iam_role_policy_attachment" "ecs_task_logging_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name   = "${var.environment}-${var.service}-ecs-task-policy"
  role   = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect   = "Allow",
      Resource = "*"
    }]
  })
  

}