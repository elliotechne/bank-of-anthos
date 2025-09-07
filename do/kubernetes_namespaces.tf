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

resource "kubernetes_namespace" "argocd" {
  depends_on = [module.cluster]
  provider   = kubernetes
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "istio-system" {
  depends_on = [module.cluster]
  provider   = kubernetes
  metadata {
    name = "istio-system"
  }
}
