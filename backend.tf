terraform {
  backend "s3" {
    bucket = "masarakki-infra"
    key    = "terraform/infra-common.tfstate"
    region = "us-west-2"
  }
}
