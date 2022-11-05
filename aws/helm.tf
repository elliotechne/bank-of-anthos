resource "helm_release" "cluster-issuer" {
  provider  = helm
  name      = "cluster-issuer"
  chart     = "charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    module.eks,
    helm_release.cert-manager,
    kubernetes_secret.zerossl_eab_hmac_key,
    kubernetes_secret.zerossl_eab_key_id
  ]
  set_sensitive {
    name  = "zerossl_email"
    value = var.zerossl_email
  }
  set_sensitive {
    name  = "zerossl_eab_hmac_key"
    value = var.zerossl_eab_hmac_key
  }
  set_sensitive {
    name  = "zerossl_eab_key_id"
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

resource "helm_release" "metrics-server" {
  provider        = helm
  repository      = local.metrics-server
  name            = "metrics-server"
  chart           = "metrics-server"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "kube-system" 
}

resource "helm_release" "istio-base" {
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-base"
  chart           = "base"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  depends_on      = [kubernetes_namespace.istio-system, helm_release.metrics-server]
}

resource "helm_release" "istiod" {
  provider        = helm
  repository      = local.istio-repo
  name            = "istiod"
  chart           = "istiod"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  set {
    name  = "kiali.enabled"
    value = "true"
  }
  set {
    name  = "servicegraph.enabled"
    value = "true"
  }
  set {
    name  = "tracing.enabled"
    value = "true"
  }
  depends_on = [helm_release.istio-base]
}

/*
resource "helm_release" "istio-ingress" {
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-ingressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  depends_on      = [helm_release.istiod, helm_release.istio-base, kubernetes_namespace.istio-ingress]
}
*/

resource "helm_release" "istio-cni" {
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-cni"
  chart           = "cni"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  depends_on      = [helm_release.istiod, helm_release.istio-base, kubernetes_namespace.istio-ingress]
}
