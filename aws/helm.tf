resource "helm_release" "cluster-issuer" {
  provider  = helm
  name      = "cluster-issuer"
  chart     = "charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    module.eks
  ]
  set_sensitive {
    name  = "zerossl_email"
    value = var.zerossl_email
  }
  set_sensitive {
    name  = "zerossl-eab-hmac-key"
    value = var.zerossl_eab_hmac_key
  }
  set_sensitive {
    name  = "zerossl-eab-key-id"
    value = var.zerossl_eab_key_id
  }
}
