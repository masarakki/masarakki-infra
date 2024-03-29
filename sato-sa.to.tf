resource "aws_route53_zone" "sato-sato" {
  name = "sato-sa.to"
  tags = {
    Project = "sato-sato"
  }
}

resource "aws_acm_certificate" "sato-sato-cert" {
  domain_name       = aws_route53_zone.sato-sato.name
  provider          = aws.global
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${aws_route53_zone.sato-sato.name}"
  ]
  tags = {
    Project = "sato-sato"
  }
}
