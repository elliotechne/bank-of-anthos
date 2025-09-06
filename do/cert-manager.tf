resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.11.1"
  namespace        = "cert-manager"
  timeout          = 120
  depends_on = [
    module.cluster,
    kubernetes_namespace.cert-manager,
  ]

  set = [
    {
      name  = "createCustomResource"
      value = "true"
    },
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}

resource "helm_release" "cluster-issuer" {
  name       = "cluster-issuer"
  chart      = "./charts/cluster-issuer"
  namespace  = "kube-system"
  depends_on = [
    helm_release.cert-manager,
  ]
  set = [
    {
      name  = "letsencrypt_email"
      value = "${var.letsencrypt_email}"
    },
    {
      name = "sslcom_keyid"
      value = "${var.sslcom_keyid}"
    },
    {
      name  = "sslcom_private_hmac_key"
      value = "${var.sslcom_private_hmac_key}"
    }
  ]
}
