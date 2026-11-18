variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "key_name" { type = string, default = null }
variable "db_endpoint" { type = string, sensitive = true }
variable "db_port" { type = number }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string, sensitive = true }
data "aws_ami" "al2023" { most_recent = true owners = ["amazon"] filter { name = "name" values = ["al2023-ami-*-x86_64"] } filter { name = "state" values = ["available"] } }
resource "aws_launch_template" "this" {
  name_prefix = "${var.project_name}-app-" image_id = data.aws_ami.al2023.id instance_type = var.instance_type key_name = var.key_name vpc_security_group_ids = [var.security_group_id]
  user_data = base64encode(templatefile("${path.root}/scripts/app.sh.tftpl", { db_endpoint = var.db_endpoint, db_port = var.db_port, db_name = var.db_name, db_username = var.db_username, db_password = var.db_password }))
  lifecycle { create_before_destroy = true }
}
resource "aws_autoscaling_group" "this" { name = "${var.project_name}-app" vpc_zone_identifier = var.subnet_ids desired_capacity = var.desired_capacity min_size = var.desired_capacity max_size = var.desired_capacity + 2 health_check_type = "EC2" launch_template { id = aws_launch_template.this.id version = "$Latest" } tag { key = "Name" value = "${var.project_name}-app" propagate_at_launch = true } }
resource "aws_lb_target_group" "this" { name = "${var.project_name}-app" port = 8080 protocol = "HTTP" vpc_id = var.vpc_id health_check { path = "/health" port = "8080" } }
resource "aws_autoscaling_attachment" "this" { autoscaling_group_name = aws_autoscaling_group.this.name lb_target_group_arn = aws_lb_target_group.this.arn }
output "target_group_arn" { value = aws_lb_target_group.this.arn }
