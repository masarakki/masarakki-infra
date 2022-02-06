resource "aws_route53_zone" "hisme_net" {
  name = "hisme.net"
}

resource "aws_route53_record" "hisme_net_mx" {
  zone_id = aws_route53_zone.hisme_net.zone_id
  name    = "hisme.net"
  type    = "MX"
  ttl     = "300"
  records = [
    "10 ASPMX.L.GOOGLE.COM",
    "30 ALT1.ASPMX.L.GOOGLE.COM",
    "30 ALT2.ASPMX.L.GOOGLE.COM",
    "50 ASPMX2.GOOGLEMAIL.COM",
    "50 ASPMX3.GOOGLEMAIL.COM",
    "50 ASPMX4.GOOGLEMAIL.COM",
    "50 ASPMX5.GOOGLEMAIL.COM",
  ]
}
