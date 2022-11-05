module "external_dns_without_irsa_policy" {
  source = "git::https://github.com/lablabs/terraform-aws-eks-external-dns"

  enabled = true

  irsa_policy_enabled              = false
  cluster_identity_oidc_issuer     = module.eks.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks.eks_cluster_identity_oidc_issuer_arn
}
