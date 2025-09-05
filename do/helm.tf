resource "helm_release" "boa" {
  provider  = helm
  name      = "boa"
  chart     = "charts/bank-of-anthos"
  namespace = "boa"
  depends_on = [
    module.cluster,
    kubernetes_namespace.boa
  ]
}
