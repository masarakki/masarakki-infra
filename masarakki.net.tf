resource "aws_route53_zone" "masarakki_net" {
  name = "masarakki.net"
  tags = {
    Project = "masarakki"
  }
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

resource "aws_route53_record" "masarakki_net_txt_records" {
  zone_id = aws_route53_zone.masarakki_net.zone_id
  name    = "masarakki.net"
  type    = "TXT"
  ttl     = "300"
  records = [
    "google-site-verification=LDCbUyoFnKmyB59S8MsADpeou7QUv4kWHBszUDGU5lM", # site verifycation
    "v=spf1 include:_spf.google.com -all", # SPF
  ]
}
