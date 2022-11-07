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
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "commonName" = var.domain_name[0]
      "dnsNames" = [
        var.domain_name[0]
      ]
      "secretName" = "argocd-tls"
    }
  }
}
