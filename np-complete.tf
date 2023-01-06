resource "aws_route53_zone" "np-complete" {
  name = "np-complete-doj.in"
  tags = {
    Project = "np-complete"
  }
}

resource "aws_acm_certificate" "np-complete-cert" {
  provider          = aws.global
  domain_name       = aws_route53_zone.np-complete.name
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${aws_route53_zone.np-complete.name}"
  ]
  tags = {
    Project = "np-complete"
  }
}

resource "aws_s3_bucket" "np-complete-books" {
  bucket   = "np-complete-books"
  provider = aws.global
  tags = {
    Project = "np-complete"
  }
}

resource "aws_s3_bucket_policy" "np-complete-books-policy" {
  bucket   = aws_s3_bucket.np-complete-books.id
  policy   = data.aws_iam_policy_document.np-complete-books.json
  provider = aws.global
}

data "aws_iam_policy_document" "np-complete-books" {
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
      "${aws_s3_bucket.np-complete-books.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "np-complete-books-public-access-block" {
  bucket                  = aws_s3_bucket.np-complete-books.id
  block_public_policy     = false
  restrict_public_buckets = false
  provider                = aws.global
}
