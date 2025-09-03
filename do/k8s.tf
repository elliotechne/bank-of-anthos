# Kubernetes Cluster
module "cluster" {
  source          = "terraform-do-modules/kubernetes/digitalocean"
  name            = local.name
  environment     = local.environment
  region          = local.region
  cluster_version = "1.33.1-do.3"
  vpc_uuid        = module.vpc.id

  critical_node_pool = {
    critical_node = {
      node_count = 1
      min_nodes  = 1
      max_nodes  = 2
      size       = "s-1vcpu-2gb"
      labels     = { "cluster" = "critical", }
      tags       = ["demo"]
      taint      = []
    }
  }

  app_node_pools = {
    app_node = {
      size       = "s-1vcpu-2gb"
      node_count = 1
      min_nodes  = 1
      max_nodes  = 2
      labels     = { "cluster" = "application" }
      tags       = ["boa"]
      taint      = []
    }
  }
}
