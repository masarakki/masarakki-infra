resource "aws_route53_zone" "sato-sato" {
  name = "sato-sa.to"
}

resource "aws_acm_certificate" "sato-sato-cert" {
  domain_name       = aws_route53_zone.sato-sato.name
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${aws_route53_zone.sato-sato.name}"
  ]
}
