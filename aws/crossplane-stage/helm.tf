resource "helm_release" "boa" {
  count     = 0 
  provider  = helm
  name      = "boa"
  chart     = "charts/bank-of-anthos"
  namespace = "boa"
  depends_on = [
    module.eks,
    kubernetes_namespace.boa
  ]
}
