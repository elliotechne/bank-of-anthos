resource "kubernetes_namespace" "boa" {
  provider   = kubernetes
  metadata {
    name = "boa"
  }
}
