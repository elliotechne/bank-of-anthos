resource "helm_release" "argocd" {
  depends_on      = [kubernetes_namespace.argocd]
  provider        = helm
  repository      = local.argocd-repo
  version         = "5.46.5"
  namespace       = "argocd"
  name            = "argocd"
  chart           = "argo-cd"
  cleanup_on_fail = true
  force_update    = true
  values = [
    local.argocd_dex_google,
    local.argocd_dex_rbac
  ]
  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }

  set {
    name  = "extensions.enabled"
    value = "true"
  }

  set {
    name  = "extensions.contents.name"
    value = "argo-rollouts"
  }

  set {
    name  = "extensions.contents.url"
    value = "https://github.com/argoproj-labs/rollout-extension/releases/download/v0.1.0/extension.tar"
  }
}

resource "helm_release" "cluster-issuer" {
  provider  = helm
  name      = "cluster-issuer"
  chart     = "charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    helm_release.cert-manager,
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

resource "helm_release" "aws-load-balancer-controller" {
  provider   = helm
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  set_sensitive {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set_sensitive {
    name  = "aws_region"
    value = var.region
  }

  set_sensitive {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set_sensitive {
    name  = "enableServiceMutatorWebhook"
    value = false
  }

}

resource "helm_release" "cert-manager" {
  provider   = helm
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.11.1"
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
  # set {
  #   name  = "extraArgs"
  #   value = "{--dns01-recursive-nameservers-only,--dns01-recursive-nameservers=169.254.169.253:53}"
  # }
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

resource "helm_release" "prometheus" {
  provider        = helm
  repository      = local.prometheus-community
  name            = "prometheus"
  chart           = "prometheus-community/prometheus"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "kube-system"
}

resource "helm_release" "istio-base" {
  provider        = helm
  count           = 0
  repository      = local.istio-repo
  name            = "istio-base"
  chart           = "base"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"
  depends_on      = [helm_release.metrics-server]
}

resource "helm_release" "istiod" {
  provider        = helm
  count           = 0
  repository      = local.istio-repo
  name            = "istiod"
  chart           = "istiod"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"
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
  depends_on = [helm_release.istio-base, helm_release.istio-cni]
}

resource "helm_release" "istio-ingress" {
  provider        = helm
  count           = 0
  repository      = local.istio-repo
  name            = "istio-ingressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-ingress"
  depends_on      = [helm_release.istiod, helm_release.istio-base]
}

resource "helm_release" "efs" {
  provider        = helm
  repository      = local.efs-repo
  name            = "efs-driver"
  chart           = "aws-efs-csi-driver"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "kube-system"
  set {
    name  = "node.dnsConfig.nameservers"
    value = "{169.254.169.253}"
  }
}

resource "helm_release" "istio-cni" {
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-cni"
  chart           = "cni"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "kube-system"
  depends_on      = [helm_release.istio-base]
}



resource "helm_release" "boa" {
  count    = 0
  provider = helm
  depends_on = [
    kubernetes_namespace.boa
  ]
  name      = "boa"
  chart     = "charts/bank-of-anthos"
  namespace = "boa"
}

resource "helm_release" "nginx-ingress" {
  provider         = helm
  repository       = local.nginx-repo
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  version          = "4.0.13"
  create_namespace = true
}
