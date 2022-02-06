resource "aws_s3_bucket" "masarakki-infra" {
  bucket = "masarakki-infra"
  acl    = "private"

  tags = {
    Project = "management"
  }
}

resource "aws_dynamodb_table" "terraform-locks" {
  name = "terraform_locks"

  read_capacity  = 1
  write_capacity = 1

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project = "management"
  }
}

terraform {
  backend "s3" {
    bucket         = "masarakki-infra"
    key            = "terraform/infra-common.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform_locks"
  }
}
