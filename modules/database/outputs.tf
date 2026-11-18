output "db_endpoint" {
  value     = aws_db_instance.this.endpoint
  sensitive = true
}

output "db_address" {
  value     = aws_db_instance.this.address
  sensitive = true
}

output "db_port" {
  value = aws_db_instance.this.port
}
