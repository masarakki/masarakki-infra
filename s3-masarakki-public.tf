resource "aws_s3_bucket" "masarakki-public" {
  bucket   = "masarakki"
  provider = aws.global

  tags = {
    Project = "masarakki"
  }
}

resource "aws_s3_bucket_policy" "masarakki-public-policy" {
  bucket   = aws_s3_bucket.masarakki-public.id
  policy   = data.aws_iam_policy_document.allow-public-access.json
  provider = aws.global
}

data "aws_iam_policy_document" "allow-public-access" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.masarakki-public.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "masarakki-public-access-block" {
  bucket                  = aws_s3_bucket.masarakki-public.id
  block_public_policy     = false
  restrict_public_buckets = false
  provider                = aws.global
}
