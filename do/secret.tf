resource "kubernetes_secret" "eab_hmac" {
  depends_on = [module.cluster, 
               kubernetes_namespace.cert-manager]
  metadata {
    name      = "zerossl-eab-secret"
    namespace = "cert-manager"
  }

  data = {
    secret = var.sslcom_private_hmac_key
  }

  type = "kubernetes.io/opaque"
}
