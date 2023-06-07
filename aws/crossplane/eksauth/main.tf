module "eks-auth" {
  source                     = "cayohollanda/eks-auth/aws"
  version                    = "0.0.1-alpha"

  k8s_endpoint               = data.aws_eks_cluster.default.endpoint 
  k8s_cluster_ca_certificate = data.aws_eks_cluster.default.certificate_authority[0].data 
  k8s_token                  = data.aws_eks_cluster_auth.default.token 
  mapRoles                   = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"
      username = "admin_role"
      groups   = ["system:masters"]
    }
  ]
}
