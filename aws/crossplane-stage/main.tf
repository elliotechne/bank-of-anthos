terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

data "aws_eks_cluster" "boa" {
  name = "BOA-${local.environment}"
}

data "aws_eks_cluster_auth" "boa" {
  name = "BOA-${local.environment}"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.boa.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.boa.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.boa.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.boa.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.boa.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.boa.token
  }
}

