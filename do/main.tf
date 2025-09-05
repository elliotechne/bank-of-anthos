terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "digitalocean" {
  token   = var.do_token
}

provider "helm" {
  kubernetes = {
    host                   = module.cluster.endpoint
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
    token                  = module.cluster.token 
  }
}

provider "kubernetes" {
  host                   =  module.cluster.endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  token                  = module.cluster.token
}

provider "kubectl" {
  host                   = module.cluster.endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  token                  = module.cluster.token
  }
}
