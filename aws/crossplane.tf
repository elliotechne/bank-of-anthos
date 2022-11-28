module "aws_provider_irsa" {
  source                            = "git::https://github.com/autotune/terraform-aws-fully-loaded-eks-cluster.git//modules/irsa"
  create_kubernetes_namespace       = false
  create_kubernetes_service_account = true
  kubernetes_namespace              = "crossplane-system" 
  irsa_iam_policies                 = concat([aws_iam_policy.aws_provider[0].arn], var.aws_provider.additional_irsa_policies)
  irsa_iam_role_path                = var.addon_context.irsa_iam_role_path
  irsa_iam_permissions_boundary     = var.addon_context.irsa_iam_permissions_boundary
  eks_cluster_id                    = module.eks.cluster_id 
  eks_oidc_provider_arn             = "https://${ module.eks.oidc_provider }"
  depends_on                        = [helm_release.crossplane-config]
}
