resource "aws_iam_openid_connect_provider" "eks" {
  depends_on      = [module.eks]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = "https://${ module.eks.oidc_provider }"
}
