module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.27"

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
    instance_types = ["t3.2xlarge"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 2
      max_size     = 10
      desired_size = 2

      instance_types = ["t3.2xlarge"]
      capacity_type  = "ON_DEMAND"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 0
      to_port                    = 65535
      type                       = "egress"
    }
  }

  node_security_group_additional_rules = merge( # {
    local.ingress_rules,
    local.egress_rules,
  )
  /*
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  } 
  */


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

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.node_additional.arn
  role       = each.value.iam_role_name
}
