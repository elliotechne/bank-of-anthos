resource "helm_release" "bank-of-anthos" {
  count     = 1
  provider  = helm
  name      = "bank-of-anthos"
  chart     = "charts/bank-of-anthos"
  namespace = "bank-of-anthos"
  depends_on = [
    module.eks,
    kubernetes_namespace.bank-of-anthos
  ]
}
