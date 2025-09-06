resource "kubernetes_config_map_v1" "argocd" {
  depends_on = [kubernetes_namespace.argocd]
  metadata {
    name      = "argpcd-rbac-cm"
    namespace = "argocd"
  }

  data = {
    "policy.default" = "role:readonly"
  }
}
