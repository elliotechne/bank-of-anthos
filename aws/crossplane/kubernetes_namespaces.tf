resource "kubernetes_namespace" "boa" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    name = "boa"
  }
}
