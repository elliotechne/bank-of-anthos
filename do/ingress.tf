resource "kubernetes_ingress_v1" "argocd" {
  depends_on = [
    helm_release.argocd,
    helm_release.cluster-issuer
  ]
  for_each = toset(var.domain_name)
  metadata {
    name      = "${each.key}-argocd-ingress"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class"          = "nginx"
      "ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer"       = "zerossl"
    }
  }
  spec {
    default_backend {
      service {
        name = "argocd-server"
        port {
          number = 80
        }
      }
    }
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = "argocd.${rule.value}"
        http {
          path {
            backend {
              service {
                name = "argocd-server"
                port {
                  number = 80
                }
              }
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domain_name)
      content {
        secret_name = "argocd-tls"
        hosts       = ["argocd.${tls.value}"]
      }
    }
  }
}

resource "kubernetes_ingress_v1" "boa" {
  depends_on = [
    helm_release.boa,
    helm_release.cluster-issuer
  ]
  for_each = toset(var.domain_name)
  metadata {
    name      = "${each.key}-frontend-ingress"
    namespace = "boa"
    annotations = {
      "kubernetes.io/ingress.class"          = "nginx"
      "ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer"       = "zerossl"
    }
  }
  spec {
    default_backend {
      service {
        name = "frontend"
        port {
          number = 80
        }
      }
    }
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = "${rule.value}"
        http {
          path {
            backend {
              service {
                name = "frontend"
                port {
                  number = 80
                }
              }
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domain_name)
      content {
        secret_name = "boa-tls"
        hosts       = ["${tls.value}"]
      }
    }
  }
}

