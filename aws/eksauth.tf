module "kube_auth" {
    source = "git::https://github.com/autotune/terraform-aws-eks-auth.git?ref=master"

    aws_region   = var.region
    cluster_name = var.eks_cluster_name
    master_roles = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"]
    nodes_role = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin_role"
    master_users = [
      {
        username  = "azuredevops"
        arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/azuredevops"
      },
      {
        username  = "root"
        arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    ]
}
