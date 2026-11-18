variable "aws_region" {
  type = string
}

variable "project_name" {
  type    = string
  default = "three-tier-demo"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = []
}

variable "key_name" {
  type    = string
  default = null
}

variable "web_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_desired_capacity" {
  type    = number
  default = 2
}

variable "app_desired_capacity" {
  type    = number
  default = 2
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type    = string
  default = "sampledb"
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_multi_az" {
  type    = bool
  default = false
}
