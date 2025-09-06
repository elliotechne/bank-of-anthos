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

resource "kubernetes_secret" "do_token" {
  metadata {
    name      = "do-token"
    namespace = "cert-manager"
  }
  data = {
    DO_TOKEN = var.do_token
  }
}
