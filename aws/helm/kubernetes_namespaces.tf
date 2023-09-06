resource "kubernetes_namespace" "upbound-system" {
  provider   = kubernetes
  metadata {
    name = "upbound-system"
    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "kubernetes_namespace" "boa" {
  provider   = kubernetes
  metadata {
    name = "boa"
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

resource "kubernetes_namespace" "boa" {
  provider   = kubernetes
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "boa"
  }
}
