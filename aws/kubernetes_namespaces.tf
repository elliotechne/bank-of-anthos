resource "kubernetes_namespace" "cert-manager" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "external-dns" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_namespace" "istio-system" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    name = "istio-system"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_namespace" "istio-ingress" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "istio-ingress"
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [module.eks]
  provider   = kubernetes
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "argocd"
  }
}
