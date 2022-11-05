module "external_dns_without_irsa_policy" {
  depends_on = [module.eks]
  source = "git::https://github.com/lablabs/terraform-aws-eks-external-dns"

  enabled = true

  irsa_policy_enabled              = false
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
}
