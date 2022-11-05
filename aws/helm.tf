resource "helm_release" "cluster-issuer" {
  provider  = helm
  name      = "cluster-issuer"
  chart     = "charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    module.eks,
    helm_release.cert-manager
  ]
  set_sensitive {
    name  = "zerossl-email"
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

resource "helm_release" "cert-manager" {
  provider   = helm
  depends_on = [kubernetes_namespace.cert-manager]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "cert-manager"
  timeout    = 120
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

