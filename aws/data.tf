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

data "aws_caller_identity" "current" {}

# arn:aws:iam::504376484015:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/FBC53B239C9F2B45538A0A01BAFDA830
output "oidc" {
  value = join("/", ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider"], 
                    [split("/", data.aws_eks_cluster.default.identity[0]["oidc"][0].issuer)[2]], 
                    [split("/", data.aws_eks_cluster.default.identity[0]["oidc"][0].issuer)[3]],
                    [split("/", data.aws_eks_cluster.default.identity[0]["oidc"][0].issuer)[4]])
}

output "cluster_id" {
  value = data.aws_eks_cluster.default.cluster_id
}

