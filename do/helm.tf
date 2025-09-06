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
