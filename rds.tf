//RDS Database


resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  engine                 = "postgres"
  engine_version         = "13" # changed the postgres13 to 13
  instance_class         = "db.t3.micro" #changed the instance class
  multi_az               = true
  db_name                = "mydb" #changed name to db_name
  username               = "username"
  password               = "password" 
  #Suggestion : Security Best Practice
  #Use AWS secrets Manager or HashiCorp Vault, to store and retrieve RDS passwords
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sgrp.id]
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.database-1.id, aws_subnet.database-2.id] 
  #moved to DB private subnets, will enhance the secuirty

}