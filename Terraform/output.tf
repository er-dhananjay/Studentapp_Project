output "studentapp_db_endpoint" {
  description = "RDS MariaDB Endpoint"
  value       = aws_db_instance.studentapp_db.address
}

output "studentapp_public_ip" {
  description = "EC2 Public IP for testing"
  value       = aws_instance.studentapp.public_ip
}
