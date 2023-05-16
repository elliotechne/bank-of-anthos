/* 
data "aws_iam_openid_connect_provider" "eks" {
  arn = "arn:aws:iam::123456789012:oidc-provider/accounts.google.com"
}
*/

data "aws_eks_cluster" "default" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = var.eks_cluster_name
}

data "aws_vpcs" "prod" {
  tags = {
    Name = "prod"
  }
}

data "aws_subnets" "prod-public" {
  filter {
    name   = "tag:Name"
    values = ["prod-public-${var.region}*"] 
  }
}
