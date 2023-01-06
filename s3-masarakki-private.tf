resource "aws_s3_bucket" "masarakki-private" {
  bucket = "masarakki-private"

  tags = {
    Project = "masarakki"
  }
}

resource "aws_s3_bucket_acl" "masarakki-private-acl" {
  bucket = aws_s3_bucket.masarakki-private.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "masarakki-private-lifecycle" {
  bucket = aws_s3_bucket.masarakki-private.id

  rule {
    id = "rule-1"
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }
}
