resource "kubernetes_manifest" "certificate_argo" {
  depends_on = [module.eks]
  provider   = kubernetes
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "argocd-cert"
      "namespace" = "istio-system"
    }
    "spec" = {
      "commonName" = "argocd.${var.domain_name[0]}"
      "dnsNames" = [
        "argocd.${var.domain_name[0]}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "commonName" = var.domain_name[0]
      "dnsNames" = [
        var.domain_name[0]
      ]
      "secretName" = "argocd-tls"
      "acme" = {
        "config" = {
          "http01" = {
            "ingressClass" = "istio"
          },
          "domains" = [
            "argocd.${var.domain_name[0]}"
          ]
        }
      }
    }
  }
}
