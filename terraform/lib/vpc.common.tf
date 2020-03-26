data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "terraform-states-goodcoin"
    key     = "vpc/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}