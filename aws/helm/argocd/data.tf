data "aws_eks_cluster" "default" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = var.eks_cluster_name
}

output "cluster_id" {
  value = data.aws_eks_cluster.default.cluster_id
}

