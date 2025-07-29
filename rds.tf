#######################################
# DB Subnet Group (for RDS placement)
#######################################
resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "rds-subnet-group"
  }
}

#######################################
# RDS Instance (Multi-AZ, Private)
#######################################
resource "aws_db_instance" "main" {
  identifier              = "main-rds"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "webapp"
  username                = "admin"
  password                = "SuperSecretPass123!" # You can move this to Secrets Manager or tfvars later
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = true
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "main-rds"
  }
}