resource "aws_s3_bucket" "advent-calendar-masarakki" {
  bucket = "advent-calendar-masarakki"

  tags = {
    Project = "public"
  }
}

resource "aws_s3_bucket_acl" "advent-calendar-masarakki-acl" {
  bucket = aws_s3_bucket.advent-calendar-masarakki.id
  acl    = "public-read"
}

resource "aws_s3_bucket_lifecycle_configuration" "advent-calendar-masarakki-lifecycle" {
  bucket = aws_s3_bucket.advent-calendar-masarakki.id

  rule {
    id = "rule-1"
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }
}
