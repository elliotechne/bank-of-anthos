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
