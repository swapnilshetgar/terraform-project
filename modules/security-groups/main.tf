resource "aws_security_group" "tier" {
  for_each = toset(["alb", "web", "app", "db"])

  name        = "${var.project_name}-${each.key}-sg"
  description = "${each.key} tier"
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.tier["alb"].id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web" {
  security_group_id            = aws_security_group.tier["web"].id
  referenced_security_group_id = aws_security_group.tier["alb"].id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app" {
  security_group_id            = aws_security_group.tier["app"].id
  referenced_security_group_id = aws_security_group.tier["web"].id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.tier["db"].id
  referenced_security_group_id = aws_security_group.tier["app"].id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}
