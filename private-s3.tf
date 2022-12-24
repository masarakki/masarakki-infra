resource "aws_s3_bucket" "masarakki" {
  bucket   = "masarakki"
  provider = aws.global

  tags = {
    Project = "private"
  }
}

resource "aws_s3_bucket" "masarakki-photos" {
  bucket   = "masarakki-photos"
  provider = aws.global

  tags = {
    Project = "private"
  }
}

resource "aws_s3_bucket_acl" "masarakki-acl" {
  bucket   = aws_s3_bucket.masarakki.id
  acl      = "private"
  provider = aws.global
}

resource "aws_s3_bucket_acl" "masarakki-photos-acl" {
  bucket   = aws_s3_bucket.masarakki-photos.id
  acl      = "private"
  provider = aws.global
}

resource "aws_s3_bucket_lifecycle_configuration" "masarakki-lifecycle" {
  bucket   = aws_s3_bucket.masarakki.id
  provider = aws.global

  rule {
    id = "rule-1"
    filter {
      prefix = "Music/"
    }
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "masarakki-photos-lifecycle" {
  bucket   = aws_s3_bucket.masarakki-photos.id
  provider = aws.global

  rule {
    id = "rule-1"
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }
}
