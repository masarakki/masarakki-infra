resource "aws_s3_bucket" "yomerakki-private" {
  bucket = "yomerakki-private"

  tags = {
    Project = "yomerakki"
  }
}

resource "aws_s3_bucket_acl" "yomerakki-private-acl" {
  bucket = aws_s3_bucket.yomerakki-private.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "yomerakki-private-lifecycle" {
  bucket = aws_s3_bucket.yomerakki-private.id

  rule {
    id = "rule-1"
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }
}
