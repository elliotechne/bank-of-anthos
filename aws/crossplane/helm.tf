resource "helm_release" "aws-auth-operator" {
  count     = 0
  provider  = helm
  name      = "aws-auth-operator"
  chart     = "charts/aws-auth-operator/chart"
  namespace = "kube-system-system"
  depends_on = [
    module.eks
  ]
}
