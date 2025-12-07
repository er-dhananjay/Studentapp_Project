resource "aws_instance" "studentapp" {
  ami                         = var.studentapp_ami
  instance_type               = var.studentapp_instance_type
  key_name                    = var.studentapp_key_name
  vpc_security_group_ids      = [var.studentapp_instance_vpc_security_group_ids]
  disable_api_termination     = var.studentapp_disable_api_termination

resource "aws_db_instance" "student_db" {
  identifier              = "studentapp"
  db_name                 = var.studentapp_db_db_name
  username                = var.studentapp_db_username
  password                = var.studentapp_db_password
  instance_class          = var.studentapp_db_instance_class
  allocated_storage       = var.studentapp_db_allocated_storage
  engine                  = "MariaDB"
  engine_version          = "11.4.8"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [var.studentapp_instance_vpc_security_group_ids]
}


  user_data = <<-EOT
#!/bin/bash
sudo apt update -y
sudo apt install -y mysql-client

git clone https://github.com/er-dhananjay/Studentapp_Project.git
cd Studentapp_Project/
chmod 700 dockerinstall.sh
sh dockerinstall.sh

docker compose up -d

# Wait for DB to be ready
until mysql -h ${var.studentapp_db_endpoint} -u ${var.studentapp_db_username} -p"${var.studentapp_db_password}" -e "select 1;" >/dev/null 2>&1; do
  echo "Waiting for RDS..."
  sleep 10
done

# Run SQL Commands
mysql -h ${aws_db_instance.student_db.address} \
     -u ${var.studentapp_db_username} \
     -p"${var.studentapp_db_password}" <<EOF
CREATE DATABASE IF NOT EXISTS studentapp;
USE studentapp;
CREATE TABLE IF NOT EXISTS students(
  student_id INT NOT NULL AUTO_INCREMENT,
  student_name VARCHAR(100) NOT NULL,
  student_addr VARCHAR(100) NOT NULL,
  student_age VARCHAR(3) NOT NULL,
  student_qual VARCHAR(20) NOT NULL,
  student_percent VARCHAR(10) NOT NULL,
  student_year_passed VARCHAR(10) NOT NULL,
  PRIMARY KEY(student_id)
);
SHOW TABLES;
EOF
EOT
}

