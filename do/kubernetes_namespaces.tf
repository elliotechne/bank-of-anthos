resource "kubernetes_namespace" "boa" {
  depends_on = [module.cluster]
  provider   = kubernetes
  metadata {
    name = "boa"
  }
}
