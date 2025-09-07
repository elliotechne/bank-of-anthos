resource "helm_release" "boa" {
  provider  = helm
  name      = "boa"
  chart     = "charts/bank-of-anthos"
  namespace = "boa"
  depends_on = [
    module.cluster,
    kubernetes_namespace.boa
  ]
}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/" 
  chart      = "external-dns"
  namespace  = "cert-manager"
  version    = "1.18.0"
  depends_on = [module.cluster, 
                kubernetes_namespace.cert-manager,
                kubernetes_secret.do_token]

      values = [<<EOF
provider:
  name: digitalocean
env:
  - name: DO_TOKEN
    valueFrom:
      secretKeyRef:
        name: do-token 
        key: DO_TOKEN
    EOF
  ]
}

resource "helm_release" "istio-base" {
  depends_on      = [helm_release.metrics-server, kubernetes_namespace.istio-system]
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-base"
  chart           = "base"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"
}

resource "helm_release" "istio-cni" {
  depends_on      = [helm_release.istio-base, kubernetes_namespace.istio-system]
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-cni"
  chart           = "cni"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "kube-system"
}

resource "helm_release" "istiod" {
  depends_on      = [helm_release.istio-base, helm_release.istio-cni, kubernetes_namespace.istio-system]
  provider        = helm
  repository      = local.istio-repo
  name            = "istiod"
  chart           = "istiod"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"
  set = [ 
    {
      name  = "meshConfig.accessLogFile"
      value = "/dev/stdout"
    },
    {
      name  = "grafana.enabled"
      value = "true"
    },
    {
      name  = "kiali.enabled"
      value = "true"
    },
    {
      name  = "servicegraph.enabled"
      value = "true"
    },
    {
      name  = "tracing.enabled"
      value = "true"
    },
  ]
  depends_on = [helm_release.istio-base, helm_release.istio-cni]
}

resource "helm_release" "istio-ingress" {
  provider        = helm
  repository      = local.istio-repo
  name            = "istio-ingressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-ingress"
  depends_on      = [helm_release.istiod, helm_release.istio-base]
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
  chart           = "kube-prometheus-stack"
  cleanup_on_fail = true
  force_update    = true
  namespace       = "kube-system"
}

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
  set = [ 
   {
     name  = "server.extraArgs"
     value = "{--insecure}"
   },

   {
     name  = "extensions.enabled"
     value = "true"
   },

   {
     name  = "extensions.contents.name"
     value = "argo-rollouts"
   },

   {
     name  = "extensions.contents.url"
     value = "https://github.com/argoproj-labs/rollout-extension/releases/download/v0.1.0/extension.tar"
   },
  ]
}

resource "helm_release" "nginx-ingress" {
  provider         = helm
  repository       = local.nginx-repo
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  version          = "4.0.13"
  create_namespace = true

  set = [{
    name  = "cluster.enabled"
    value = "true"
  },

  {
    name  = "metrics.enabled"
    value = "true"
  },
  ]
}
