data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "default" {
  depends_on = [module.eks]
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  depends_on = [module.eks]
  name = module.eks.cluster_name
}
