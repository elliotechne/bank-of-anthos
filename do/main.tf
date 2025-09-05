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
    host  = data.digitalocean_kubernetes_cluster.boa.endpoint
    token = data.digitalocean_kubernetes_cluster.boa.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.boa.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.boa.endpoint
  token = data.digitalocean_kubernetes_cluster.boa.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.boa.kube_config[0].cluster_ca_certificate
  )
}

provider "kubectl" {
  host  = data.digitalocean_kubernetes_cluster.boa.endpoint
  token = data.digitalocean_kubernetes_cluster.boa.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.boa.kube_config[0].cluster_ca_certificate
  )
}
