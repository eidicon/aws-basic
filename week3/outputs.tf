output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.edu-12.address
  sensitive   = false
}
output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.edu-12.port
  sensitive   = false
}
