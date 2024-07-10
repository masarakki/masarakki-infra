resource "aws_route53_zone" "sato-sato" {
  name = "sato-sa.to"
  tags = {
    Project = "sato-sa.to"
  }
}

resource "aws_acm_certificate" "sato-sato-cert" {
  domain_name       = aws_route53_zone.sato-sato.name
  provider          = aws.global
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${aws_route53_zone.sato-sato.name}"
  ]
  tags = {
    Project = "sato-sa.to"
  }
}

resource "aws_s3_bucket" "sato-sato" {
  bucket = "sato-sa.to"
  tags = {
    Project = "sato-sa.to"
  }
}

resource "aws_s3_bucket_public_access_block" "sato-sato" {
  bucket                  = aws_s3_bucket.sato-sato.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "sato-sato-cloudfront-policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.sato-sato.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.sato-sato.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "sato-sato" {
  bucket = aws_s3_bucket.sato-sato.id
  policy = data.aws_iam_policy_document.sato-sato-cloudfront-policy.json
}

resource "aws_cloudfront_origin_access_control" "sato-sato" {
  name                              = "s3-origin-access-control-for-sato-sato"
  description                       = ""
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "sato-sa.to-s3-origin"
}

resource "aws_cloudfront_distribution" "sato-sato" {
  origin {
    domain_name              = aws_s3_bucket.sato-sato.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.sato-sato.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["sato-sa.to"]

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.sato-sato-cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Project = "sato-sa.to"
  }
}

data "aws_iam_policy_document" "sato-sato-github-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:tanoseesaw/sato-sa.to:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "deploy-sato-sato-policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.sato-sato.arn}",
      "${aws_s3_bucket.sato-sato.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      aws_cloudfront_distribution.sato-sato.arn
    ]
  }
}

resource "aws_iam_role" "deploy-sato-sato-role" {
  name               = "deploy-sato-sato-role"
  assume_role_policy = data.aws_iam_policy_document.sato-sato-github-assume-role-policy.json

  inline_policy {
    policy = data.aws_iam_policy_document.deploy-sato-sato-policy.json
    name   = "deploy-sato-sato-policy"
  }

  tags = {
    Project = "sato-sa.to"
  }
}
