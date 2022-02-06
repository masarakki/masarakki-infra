resource "aws_route53_zone" "masarakki_net" {
  name = "masarakki.net"
}

resource "aws_route53_record" "masarakki_net_mx" {
  zone_id = aws_route53_zone.masarakki_net.zone_id
  name    = "masarakki.net"
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
