module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.27"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.27"

  create_iam_role = false
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  enable_irsa = true

  cluster_addons = {
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # aws-auth configmap
  # we use external module to manage 
  manage_aws_auth_configmap = false 
  create_aws_auth_configmap = true

  node_security_group_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = null
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

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"
      username = "admin_role"
      groups   = ["system:masters", "system:nodes", "system:serviceaccount:runners:default"]
    },
    {
      rolearn  = "arn:aws:iam::504376484015:role/green-eks-node-group-20230604190046714400000001"
      username = "crossplane_role"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/azuredevops"
      username = "azuredevops"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "${data.aws_caller_identity.current.account_id}",
  ]

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = var.eks_cluster_name
  cluster_name    = var.eks_cluster_name 
  cluster_version = "1.27"

  subnet_ids = module.vpc.public_subnets 

  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id]

  min_size     = 1
  max_size     = 4
  desired_size = 2

  instance_types = ["t3.xlarge"]
  capacity_type  = "SPOT"

  create_iam_role = false 
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"

  labels = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
}

resource "aws_eks_addon" "coredns" {
  depends_on = [module.eks_managed_node_group]
  cluster_name = var.eks_cluster_name
  addon_name   = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${local.name}"
  role = module.eks_managed_node_group.iam_role_name
}


module "karpenter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on = [module.kube_auth]

  role_name                          = "karpenter_controller"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = module.eks.cluster_id
  karpenter_controller_node_iam_role_arns = [
    module.eks_managed_node_group.iam_role_arn
  ]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

data "aws_ecrpublic_authorization_token" "token" {
  provider=aws.virginia
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "v0.30.0"

  set {
    name  = "settings.aws.clusterName"
    value = module.eks.cluster_name 
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter_irsa.iam_role_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = "KarpenterNodeInstanceProfile-${local.name}" 
  }
}

data "http" "karpenter_crds" {
  url = "https://raw.githubusercontent.com/aws/karpenter/v0.30.0/pkg/apis/crds/karpenter.sh_provisioners.yaml"
}

data "kubectl_file_documents" "karpenter_crds" {
  content = data.http.karpenter_crds.response_body
}

resource "kubectl_manifest" "karpenter_crds" {
  for_each  = data.kubectl_file_documents.karpenter_crds.manifests
  yaml_body = each.value
}

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: default
  spec:
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot"]
    limits:
      resources:
        cpu: 1000
    provider:
      subnetSelector:
        karpenter.sh/discovery: ${local.name}
      securityGroupSelector:
        karpenter.sh/discovery: ${local.name}
      tags:
        karpenter.sh/discovery: ${local.name}
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [helm_release.karpenter, kubectl_manifest.karpenter_crds]
}
