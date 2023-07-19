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

data "aws_iam_policy_document" "np-complete-github-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:np-complete/*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "upload-np-complete-books-policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.np-complete-books.arn}/*"
    ]
  }
}
resource "aws_iam_role" "publish-np-complete-book-role" {
  name               = "publish-np-complete-book-role"
  assume_role_policy = data.aws_iam_policy_document.np-complete-github-assume-role-policy.json

  inline_policy {
    policy = data.aws_iam_policy_document.upload-np-complete-books-policy.json
    name   = "upload-np-complete-book-policy"
  }

  tags = {
    Project = "np-complete"
  }
}
