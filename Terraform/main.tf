############################################
# SECURITY GROUPS
############################################

# Security Group for EC2 Instance
resource "aws_security_group" "studentapp_instance_sg" {
  name        = "studentapp-instance-sg"
  description = "Allow HTTP 80 & DB access outbound"
  vpc_id      = var.vpc_id

  ingress {
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
}

# Security Group for RDS MariaDB
resource "aws_security_group" "studentapp_db_sg" {
  name        = "studentapp-db-sg"
  description = "Allow MariaDB 3306 from EC2 only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.studentapp_instance_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# RDS MARIADB (Public Access)
############################################
resource "aws_db_instance" "studentapp_db" {
  identifier             = "studentapp-db"
  allocated_storage      = var.studentapp_db_allocated_storage
  engine                 = "mariadb"
  engine_version         = "11.4.8"
  instance_class         = var.studentapp_db_instance_class
  username               = var.studentapp_db_username
  password               = var.studentapp_db_password
  port                   = 3306
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.studentapp_db_sg.id]

  depends_on = [aws_security_group.studentapp_db_sg]
}

############################################
# EC2 INSTANCE WITH USER_DATA
############################################
resource "aws_instance" "studentapp" {
  ami                    = var.studentapp_ami
  instance_type          = var.studentapp_instance_type
  key_name               = var.studentapp_key_name
  vpc_security_group_ids = [aws_security_group.studentapp_instance_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  apt update -y
  apt install docker.io mysql-client -y
  systemctl start docker
  systemctl enable docker

  # Wait for DB to be ready
  sleep 60
  
  # Create database if not exists
  mysql -h ${aws_db_instance.studentapp_db.address} -u ${var.studentapp_db_username} -p${var.studentapp_db_password} -e "CREATE DATABASE IF NOT EXISTS studentapp;"

  # Start StudentApp Docker container
  docker run -d --name studentapp \
    -p 80:8080 \
    -e DB_HOST="${aws_db_instance.studentapp_db.address}" \
    -e DB_PORT="3306" \
    -e DB_USER="${var.studentapp_db_username}" \
    -e DB_PASS="${var.studentapp_db_password}" \
    -e DB_NAME="studentapp" \
    studentapp:latest
  EOF

  depends_on = [aws_db_instance.studentapp_db]
}
