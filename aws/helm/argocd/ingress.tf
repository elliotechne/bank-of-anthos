resource "kubernetes_ingress_v1" "argocd" {
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
        host = "cicd.${rule.value}"
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
        secret_name = "${tls.value}-argo-tls"
        hosts       = ["cicd.${tls.value}"]
      }
    }
  }
}

