resource "kubernetes_namespace" "boa" {
  depends_on = [module.cluster]
  provider   = kubernetes
  metadata {
    name = "boa"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  depends_on = [module.cluster]
  provider   = kubernetes
  metadata {
    name = "cert-manager"
  }
}
