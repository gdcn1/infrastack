provider "aws" {
  region  = "eu-west-1"
  profile = "goodcoin"
}

terraform {
  backend "s3" {
    profile = "goodcoin"
  }
}
