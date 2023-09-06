resource "kubernetes_secret" "eab_hmac" {
  metadata {
    name      = "zerossl-eab-hmac-key"
    namespace = "kube-system"
  }

  data = {
    secret = var.zerossl_eab_hmac_key
  }

  type = "kubernetes.io/opaque"
}
