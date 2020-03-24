module "terraform_states_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "terraform-states-goodcoin"
  acl    = "private"
  region = "eu-west-1"

  versioning = {
    enabled    = true
    mfa_delete = false
  }

  tags = {
    Name    = "terraform-states-goodcoin"
    Purpose = "Contains terraform state files"
    Warning = "Managed by terraform do not edit"
  }
}
