resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = var.app_tag
  }
}
