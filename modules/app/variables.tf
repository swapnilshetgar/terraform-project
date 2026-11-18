variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
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

variable "db_endpoint" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
