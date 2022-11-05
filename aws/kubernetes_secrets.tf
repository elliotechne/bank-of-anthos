resource "kubernetes_secret" "zerossl_eab_hmac_key" {
  provider   = kubernetes
  depends_on = [module.eks]
  metadata {
    name      = "zerossl_eab_hmac_key"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_hmac_key
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "zerossl_eab_key_id" {
  provider   = kubernetes
  depends_on = [module.eks]
  metadata {
    name      = "zerossl_eab_hmac_key_id"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_hmac_key_id
  }

  type = "kubernetes.io/opaque"
}
