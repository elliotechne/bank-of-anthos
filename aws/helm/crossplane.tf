resource "helm_release" "crossplane-aws" {
  provider   = helm
  name       = "crossplane-stable"
  repository = "https://charts.crossplane.io/stable/"
  chart      = "crossplane"
  version    = "1.10.1"
  namespace  = "crossplane-system"
  timeout    = 120

  set_sensitive {
    name  = "provider.packages"
    value = "{xpkg.upbound.io/crossplane-contrib/provider-aws:v0.33.0}"
  }
}

resource "helm_release" "crossplane-terraform-install" {
  provider   = helm
  depends_on = [helm_release.crossplane-aws]
  name       = "crossplane-terraform"
  chart      = "charts/crossplane-terraform-install"
  version    = "0.0.13"
  namespace  = "crossplane-system"
  timeout    = 120

  set {
    name  = "crossplane_aws_role_arn"
    value = module.aws_provider_irsa.irsa_iam_role_arn
  }
}

resource "helm_release" "crossplane-terraform-config" {
  provider   = helm
  depends_on = [helm_release.crossplane-terraform-install]
  name       = "crossplane-terraform-config"
  chart      = "charts/crossplane-terraform-config"
  version    = "0.0.13"
  namespace  = "crossplane-system"
  timeout    = 120

  set {
    name  = "s3bucket"
    value = var.crossplane_s3_bucket
  }

  set {
    name  = "tfstate_key"
    value = var.crossplane_tfstate_key
  }

  set_sensitive {
    name  = "region"
    value = var.region
  }
}

resource "helm_release" "crossplane-config" {
  provider  = helm
  name      = "crossplane-config"
  chart     = "charts/crossplane-config"
  namespace = "crossplane-system"
  depends_on = [
    helm_release.crossplane-aws
  ]
}

resource "helm_release" "crossplane-workspaces" {
  provider  = helm
  name      = "crossplane-workspaces"
  chart     = "charts/crossplane-workspaces"
  namespace = "crossplane-system"
  depends_on = [
    helm_release.crossplane-terraform-config
  ]
}

module "aws_provider_irsa" {
  source                            = "git::https://github.com/autotune/terraform-aws-fully-loaded-eks-cluster.git//modules/irsa"
  create_kubernetes_namespace       = false
  create_kubernetes_service_account = false
  kubernetes_namespace              = "crossplane-system" 
  kubernetes_service_account        = "crossplane-config"
  irsa_iam_policies                 = [aws_iam_policy.aws_provider.arn]
  # [aws_iam_policy.aws_provider.arn]
  irsa_iam_role_path                = var.irsa_iam_role_path
  irsa_iam_permissions_boundary     = var.irsa_iam_permissions_boundary
  eks_cluster_id                    = data.aws_eks_cluster.default.cluster_id 
  eks_oidc_provider_arn             = local.eks_oidc_provider_arn
  # depends_on                        = [helm_release.crossplane-config]
}

resource "aws_iam_policy" "aws_provider" {
  description = "Crossplane AWS Provider IAM policy"
  # name        = "${var.eks_cluster_name}-irsa"
  policy      = data.aws_iam_policy_document.s3_policy.json
}
