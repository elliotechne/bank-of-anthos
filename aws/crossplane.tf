module "aws_provider_irsa" {
  source                            = "git::https://github.com/autotune/terraform-aws-fully-loaded-eks-cluster.git//modules/irsa"
  create_kubernetes_namespace       = false
  create_kubernetes_service_account = true
  kubernetes_namespace              = "crossplane-system" 
  kubernetes_service_account        = "crossplane-config"
  irsa_iam_policies                 = [aws_iam_policy.aws_provider.arn]
  irsa_iam_role_path                = var.irsa_iam_role_path
  irsa_iam_permissions_boundary     = var.irsa_iam_permissions_boundary
  eks_cluster_id                    = module.eks.cluster_id 
  eks_oidc_provider_arn             = "https://${ module.eks.oidc_provider }"
  depends_on                        = [helm_release.crossplane-config]
}

resource "aws_iam_policy" "aws_provider" {
  description = "Crossplane AWS Provider IAM policy"
  name        = "${module.eks.cluster_id}-${local.aws_provider_sa}-irsa"
  policy      = data.aws_iam_policy_document.s3_policy.json
}
