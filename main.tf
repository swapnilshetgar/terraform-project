data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = length(var.availability_zones) >= 2 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = local.azs
}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "database" {
  source            = "./modules/database"
  project_name      = var.project_name
  subnet_ids        = module.vpc.database_subnet_ids
  security_group_id = module.security_groups.security_group_ids["db"]
  instance_class    = var.db_instance_class
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  multi_az          = var.db_multi_az
}

module "app" {
  source           = "./modules/app"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.app_subnet_ids
  security_group_id = module.security_groups.security_group_ids["app"]
  instance_type    = var.app_instance_type
  desired_capacity = var.app_desired_capacity
  key_name         = var.key_name
  db_endpoint      = module.database.db_address
  db_port          = module.database.db_port
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

module "web" {
  source                = "./modules/web"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  subnet_ids            = module.vpc.web_subnet_ids
  security_group_id     = module.security_groups.security_group_ids["web"]
  alb_security_group_id = module.security_groups.security_group_ids["alb"]
  app_target_group_arn  = module.app.target_group_arn
  instance_type         = var.web_instance_type
  desired_capacity      = var.web_desired_capacity
  key_name              = var.key_name
  app_port              = 8080
}
