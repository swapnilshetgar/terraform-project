output "website_url" { value = "http://${module.web.alb_dns_name}" }
output "alb_dns_name" { value = module.web.alb_dns_name }
output "vpc_id" { value = module.vpc.vpc_id }
output "db_endpoint" { value = module.database.db_endpoint sensitive = true }
