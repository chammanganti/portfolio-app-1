resource "aws_lb" "main" {
  name               = "portfolioapp1"
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.allow_all_local.id,
    aws_security_group.allow_all_http.id,
    aws_security_group.allow_all_https.id
  ]
  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.public_3.id,
  ]

  enable_deletion_protection = false

  tags = {
    Name = var.app_tag
  }
}
