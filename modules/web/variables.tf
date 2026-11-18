variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "app_target_group_arn" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "key_name" {
  type    = string
  default = null
}

variable "app_port" {
  type = number
}
