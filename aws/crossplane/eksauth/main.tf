module "kube_auth" {
    source = "koslib/eks-auth/aws"
    version = "0.1.0"

    aws_region   = var.region 
    cluster_name = var.eks_cluster_name 
    master_roles = [
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"
        username = "admin_role"
        groups   = ["system:masters"]
      }
    ]
}
