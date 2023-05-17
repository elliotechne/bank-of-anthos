resource "kubernetes_namespace" "crossplane-system" {
  provider   = kubernetes
  metadata {
    name = "crossplane-system"
    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "kubernetes_namespace" "cert-manager" {
  provider   = kubernetes
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "external-dns" {
  provider   = kubernetes
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_namespace" "istio-system" {
  provider   = kubernetes
  metadata {
    name = "istio-system"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_namespace" "istio-ingress" {
  provider   = kubernetes
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "istio-ingress"
  }
}

resource "kubernetes_namespace" "argocd" {
  provider   = kubernetes
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "argocd"
  }
}
