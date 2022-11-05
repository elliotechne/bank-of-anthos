module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "prod"
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  enable_irsa = true 

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = [ module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 2
      max_size     = 10
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::233510574809:user/badams"
      username = "badams"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::233510574809:user/azuredevops"
      username = "azuredevops"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "233510574809",
  ]

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
