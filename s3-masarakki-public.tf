resource "aws_s3_bucket" "masarakki-public" {
  bucket   = "masarakki"
  provider = aws.global

  tags = {
    Project = "masarakki"
  }
}

resource "aws_s3_bucket_acl" "masarakki-public-acl" {
  bucket   = aws_s3_bucket.masarakki-public.id
  acl      = "public-read"
  provider = aws.global
}
