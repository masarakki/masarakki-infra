resource "aws_route53_zone" "np-complete" {
  name = "np-complete-doj.in"
  tags = {
    Project = "np-complete"
  }
}

resource "aws_acm_certificate" "np-complete-cert" {
  provider          = aws.global
  domain_name       = aws_route53_zone.np-complete.name
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${aws_route53_zone.np-complete.name}"
  ]
  tags = {
    Project = "np-complete"
  }
}
