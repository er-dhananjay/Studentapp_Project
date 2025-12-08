resource "aws_db_instance" "student_db" {
  identifier             = "studentapp"
  db_name                = var.studentapp_db_db_name
  username               = var.studentapp_db_username
  password               = var.studentapp_db_password
  instance_class         = var.studentapp_db_instance_class
  allocated_storage      = var.studentapp_db_allocated_storage
  engine                 = "mariadb"
  engine_version         = "11.4.8"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [var.studentapp_instance_vpc_security_group_ids]
}

resource "aws_instance" "studentapp" {
  ami                    = var.studentapp_ami
  instance_type          = var.studentapp_instance_type
  key_name               = var.studentapp_key_name
  vpc_security_group_ids = [var.studentapp_instance_vpc_security_group_ids]
  disable_api_termination = var.studentapp_disable_api_termination

  depends_on = [aws_db_instance.student_db]

  user_data = <<-EOT
#!/bin/bash
set -e

# Update packages
sudo apt update -y

# Install dependencies
sudo apt install -y git docker.io docker-compose-plugin mysql-client

# Ensure Docker is running
sudo systemctl enable docker
sudo systemctl start docker

# Clone app repo
cd /opt
if [ ! -d "Studentapp_Project" ]; then
  git clone https://github.com/er-dhananjay/Studentapp_Project.git
fi
cd Studentapp_Project

# Run docker installation script (if it exists)
chmod +x dockerinstall.sh || true
sh dockerinstall.sh || true

# Bring up containers
docker compose up -d || docker-compose up -d || true

# Wait for RDS to be ready
until mysql -h ${aws_db_instance.student_db.address} -u ${var.studentapp_db_username} -p"${var.studentapp_db_password}" -e "select 1;" >/dev/null 2>&1; do
  echo "Waiting for RDS..."
  sleep 10
done

# Initialize database and table
mysql -h ${aws_db_instance.student_db.address} \
  -u ${var.studentapp_db_username} \
  -p"${var.studentapp_db_password}" <<EOF
CREATE DATABASE IF NOT EXISTS ${var.studentapp_db_db_name};
USE ${var.studentapp_db_db_name};
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
EOF
EOT
}

output "studentapp_publicip" {
  value = aws_instance.studentapp.public_ip
}
