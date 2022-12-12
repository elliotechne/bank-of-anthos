module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.23"

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
  subnet_ids = flatten([module.vpc.private_subnets, module.vpc.public_subnets])

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t2.medium"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1 
      max_size     = 2
      desired_size = 2

      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true 
  # create_aws_auth_configmap = true

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = merge( # {
    local.ingress_rules,
    local.egress_rules
  )

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::233510574809:role/AdminAccess"
      username = "AdminAccess"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
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
