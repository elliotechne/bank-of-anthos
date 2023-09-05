resource "kubernetes_ingress" "argocd" {
  metadata {
    name      = "argocd"
    namespace = "argocd" 
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "external-dns.alpha.kubernetes.io/hostname" = "argocd.${var.domain_name[0]}"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = "argocd-server"
            service_port = 443 
          }
        }
      }
    }
  }
}
