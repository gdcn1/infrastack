data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    bucket  = "terraform-states-good-coin"
    key     = "route53/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
