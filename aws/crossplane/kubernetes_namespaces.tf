resource "kubernetes_namespace" "bank-of-anthos" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    name = "bank-of-anthos"
  }
}
