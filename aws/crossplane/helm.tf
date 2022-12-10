resource "helm_release" "bank-of-anthos" {
  count     = 1
  provider  = helm
  name      = "bank-of-anthos"
  chart     = "charts/bank-of-anthos"
  namespace = "default"
  depends_on = [
    module.eks
  ]
}
