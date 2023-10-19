resource "aws_security_group" "alb_sg" {
  name        = "app-lb-sg"
  description = "Enable external http traffic for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group" "webhost_sg" {
  name        = "webhost-sg"
  description = "Enable http traffic between ALB and Web servers and ssh mgmt traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = {
    Name = "webhost_sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Enable connection between webhosts and mysql RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "db access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webhost_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    security_groups = [aws_security_group.webhost_sg.id]
  }

  tags = {
    Name = "database_sg"
  }
}


resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Security group for efs"
  vpc_id      = var.vpc_id

  ingress {
    description = "efs access"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.webhost_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "efs_sg"
  }
}
