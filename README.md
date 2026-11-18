# AWS Three-Tier Website with Terraform

Deploys `Internet -> public ALB -> private web ASG (Nginx) -> private app ASG (Flask:8080) -> private RDS MySQL`.

## Prerequisites

- Terraform >= 1.6 and AWS CLI
- AWS credentials configured with `aws configure` or environment variables
- Permissions for VPC, EC2, ELB, Auto Scaling, and RDS

## Deploy

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
# Set db_password and review the region.
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
terraform output -raw website_url
```

Destroy the demo when finished: `terraform destroy`.

Do not commit `terraform.tfvars`, plan files, or state. Terraform state contains the database password; use an encrypted, access-controlled remote backend in real environments. Production deployments should use Secrets Manager and password rotation.

## Layout

`modules/vpc` creates public, web, app, and database subnets plus NAT. `modules/security-groups` creates ALB/web/app/db SGs with only `ALB -> web -> app -> DB` ingress. `modules/web` creates the ALB and Nginx ASG. `modules/app` creates the Flask ASG. `modules/database` creates private RDS MySQL. Bootstrap templates install the sample application. `database/schema.sql` documents the application table; the Flask endpoint also creates it on first request so no public database access is needed.

## Troubleshooting

- ALB target health: web instances must answer `/health` on port 80.
- Bootstrap logs: `sudo tail -n 200 /var/log/cloud-init-output.log`.
- Services: `systemctl status nginx` and `systemctl status sample-app`.
- Private instances need NAT access during package installation; NAT gateways incur AWS charges.
- The RDS endpoint is private and is only reachable from the app security group.
