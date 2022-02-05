resource "aws_s3_bucket" "masarakki-infra" {
  bucket = "masarakki-infra"
  acl    = "private"
}
