resource "aws_db_subnet_group" "db-snet-group" {
  name       = "db-snet-group"
  subnet_ids = [aws_subnet.db-snet-1.id,aws_subnet.db-snet-2.id]
}

resource "aws_db_instance" "app_db" {
  availability_zone      = "eu-central-1a"
  engine                  = "mysql"
  engine_version          = "5.7.43"
  instance_class          = "db.t2.micro"
  #db_instance_class       = "db.m5.large"
  allocated_storage       = 20
  username                = "admin"
  password                = "Password123"
  multi_az                = false
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0


  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  db_subnet_group_name = aws_db_subnet_group.db-snet-group.name

  tags = {
    Name = "AppDB"
  }
}

