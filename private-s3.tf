resource "aws_s3_bucket" "masarakki-photos" {
  bucket   = "masarakki-photos"
  provider = aws.global

  tags = {
    Project = "private"
  }
}

resource "aws_s3_bucket_acl" "masarakki-photos-acl" {
  bucket = aws_s3_bucket.masarakki-photos.id
  acl    = "private"
}
