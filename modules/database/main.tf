variable "project_name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "instance_class" { type = string }
variable "db_name" { type = string }
variable "username" { type = string }
variable "password" { type = string sensitive = true }
variable "multi_az" { type = bool }
resource "aws_db_subnet_group" "this" { name = "${var.project_name}-db-subnets" subnet_ids = var.subnet_ids tags = { Name = "${var.project_name}-db-subnets" } }
resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-mysql" engine = "mysql" engine_version = "8.0" instance_class = var.instance_class
  allocated_storage = 20 max_allocated_storage = 100 storage_type = "gp3" db_name = var.db_name username = var.username password = var.password port = 3306
  db_subnet_group_name = aws_db_subnet_group.this.name vpc_security_group_ids = [var.security_group_id] multi_az = var.multi_az publicly_accessible = false
  backup_retention_period = 7 deletion_protection = false skip_final_snapshot = true apply_immediately = true
}
output "db_endpoint" { value = aws_db_instance.this.endpoint sensitive = true }
output "db_address" { value = aws_db_instance.this.address sensitive = true }
output "db_port" { value = aws_db_instance.this.port }
