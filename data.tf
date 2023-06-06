data "aws_availability_zones" "available" {}

data "aws_key_pair" "main" {
  key_name = "main"
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = [var.app_tag]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_acm_certificate" "this" {
  domain   = "chammanganti.dev"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "selected" {
  name = "chammanganti.dev"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Servie"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
