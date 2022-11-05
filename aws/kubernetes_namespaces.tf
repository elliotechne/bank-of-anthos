resource "kubernetes_namespace" "cert-manager" {
  depends_on = [module.eks]
  provider   = kubernetes.cinema
  metadata {
    name = "cert-manager"
    labels = {
      "istio.io/rev" = "asm-managed-regular"
    }
  }
}

resource "kubernetes_namespace" "external-dns" {
  depends_on = [module.eks]
  provider   = kubernetes.cinema
  metadata {
    name = "external-dns"
  }
}
