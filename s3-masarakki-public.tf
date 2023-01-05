resource "aws_s3_bucket" "masarakki-public" {
  bucket = "masarakki-public"

  tags = {
    Project = "public"
  }
}

resource "aws_s3_bucket_acl" "masarakki-public-acl" {
  bucket = aws_s3_bucket.masarakki-public.id
  acl    = "public-read"
}

resource "aws_s3_bucket_lifecycle_configuration" "masarakki-public-lifecycle" {
  bucket = aws_s3_bucket.masarakki-public.id

  rule {
    id = "rule-1"
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }
}
