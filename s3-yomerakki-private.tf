resource "aws_s3_bucket" "yomerakki-private" {
  bucket = "yomerakki-private"

  tags = {
    Project = "yomerakki"
  }
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

data "aws_iam_policy_document" "yomerakki-private-access-policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.yomerakki-private.arn}",
      "${aws_s3_bucket.yomerakki-private.arn}/*"
    ]
  }
}

resource "aws_iam_user_policy" "attach-yomerakki-private-access-policy-to-tanoseesaw" {
  name   = "yomerakki-private-full-access-policy"
  user   = aws_iam_user.tanoseesaw.name
  policy = data.aws_iam_policy_document.yomerakki-private-access-policy.json
}
