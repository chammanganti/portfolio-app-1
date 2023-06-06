resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }
}
