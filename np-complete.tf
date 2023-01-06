resource "aws_route53_zone" "np-complete" {
  name = "np-complete-doj.in"
  tags = {
    Project = "np-complete"
  }
}
