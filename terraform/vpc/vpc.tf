module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "goodcoin_vpc"
  cidr = "172.31.248.0/21"

  azs            = ["us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets = ["172.31.252.0/24", "172.31.253.0/24", "172.31.254.0/23"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Name    = "goodcoin_vpc"
    Purpose = "VPC for goodcoin project"
    Warning = "Managed by terraform do not edit"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
