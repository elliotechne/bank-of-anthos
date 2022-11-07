resource "kubernetes_ingress" "atlantis_events_cluster_ingress" {
  depends_on = [
    helm_release.argocd
  ]
  for_each = toset(var.domain_name)
  metadata {
    name = "${each.key}-argocd-ingress"
    namespace  = "argocd"
    annotations = {
        "kubernetes.io/ingress.class" = "istio"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = "argocd.${rule.value}"
        http {
          path {
            backend {
              service_name = "argocd-server"
              service_port = 80 
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
        hosts = ["argocd.${tls.value}"]
      }
    }
  }
}

