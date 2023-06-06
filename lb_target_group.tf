resource "aws_lb_target_group" "http80" {
  name     = "portfolioapp1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = var.app_tag
  }
}
