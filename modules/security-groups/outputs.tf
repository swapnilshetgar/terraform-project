output "security_group_ids" {
  value = {
    for name, group in aws_security_group.tier :
    name => group.id
  }
}
