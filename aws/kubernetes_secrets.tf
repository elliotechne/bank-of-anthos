resource "kubernetes_secret" "zerossl_eab_hmac_key" {
  provider   = kubernetes
  depends_on = [module.eks]
  metadata {
    name      = "zerossl-eab-hmac-key"
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
    name      = "zerossl-eab-hmac-key-id"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_key_id
  }

  type = "kubernetes.io/opaque"
}
