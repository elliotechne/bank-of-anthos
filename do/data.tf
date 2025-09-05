data "digitalocean_kubernetes_cluster" "boa" {
  name = "${local.name}-${local.environment}-cluster"
}
