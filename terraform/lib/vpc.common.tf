data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "terraform-states-good-coin"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
