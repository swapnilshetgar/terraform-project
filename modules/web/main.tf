variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "alb_security_group_id" { type = string }
variable "app_target_group_arn" { type = string }
variable "instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "key_name" { type = string, default = null }
variable "app_port" { type = number }
data "aws_ami" "al2023" { most_recent = true owners = ["amazon"] filter { name = "name" values = ["al2023-ami-*-x86_64"] } filter { name = "state" values = ["available"] } }
resource "aws_lb" "this" { name = "${var.project_name}-alb" internal = false load_balancer_type = "application" subnets = var.public_subnet_ids security_groups = [var.alb_security_group_id] }
resource "aws_lb_target_group" "web" { name = "${var.project_name}-web" port = 80 protocol = "HTTP" vpc_id = var.vpc_id health_check { path = "/health" } }
resource "aws_lb_listener" "http" { load_balancer_arn = aws_lb.this.arn port = 80 protocol = "HTTP" default_action { type = "forward" target_group_arn = aws_lb_target_group.web.arn } }
resource "aws_launch_template" "this" { name_prefix = "${var.project_name}-web-" image_id = data.aws_ami.al2023.id instance_type = var.instance_type key_name = var.key_name vpc_security_group_ids = [var.security_group_id] user_data = base64encode(templatefile("${path.root}/scripts/web.sh.tftpl", { app_port = var.app_port })) lifecycle { create_before_destroy = true } }
resource "aws_autoscaling_group" "this" { name = "${var.project_name}-web" vpc_zone_identifier = var.subnet_ids desired_capacity = var.desired_capacity min_size = var.desired_capacity max_size = var.desired_capacity + 2 health_check_type = "ELB" launch_template { id = aws_launch_template.this.id version = "$Latest" } tag { key = "Name" value = "${var.project_name}-web" propagate_at_launch = true } }
resource "aws_autoscaling_attachment" "web" { autoscaling_group_name = aws_autoscaling_group.this.name lb_target_group_arn = aws_lb_target_group.web.arn }
output "alb_dns_name" { value = aws_lb.this.dns_name }
