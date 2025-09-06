resource "kubernetes_secret" "eab_hmac" {
  depends_on = [module.cluster, 
               kubernetes_namespace.cert-manager]
  metadata {
    name      = "zerossl-eab-hmac-key"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_hmac_key
  }

  type = "kubernetes.io/opaque"
}
