resource "aws_s3_bucket" "masarakki-photos" {
  bucket   = "masarakki-photos"
  acl      = "private"
  provider = aws.global

  tags = {
    Project = "private"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "photos-entier-bucket" {
  bucket = aws_s3_bucket.masarakki-photos.bucket
  name   = "EntierBucket"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 60
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}
