variable "map_users" {
  default = [
    {
      userarn  = "arn:aws:iam::671114993430:user/circleci"
      username = "circleci"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_iam_policy" "route53_policy" {
  name        = "route53_police"
  description = "Policy for external-dns chart"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${data.terraform_remote_state.route53.outputs.route53_zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "goodcoin-eks-spot"
  subnets      = data.terraform_remote_state.vpc.outputs.public_subnets
  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id

  worker_groups_launch_template = [
    {
      name                    = "eks-spot-1"
      override_instance_types = ["t3.micro", "t3.small", "t3.medium"]
      spot_instance_pools     = 2
      asg_max_size            = 4
      asg_desired_capacity    = 4
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      public_ip               = true
    },
  ]

  map_users = var.map_users

  workers_additional_policies = [aws_iam_policy.route53_policy.arn]
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}
