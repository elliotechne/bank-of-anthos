terraform {
  backend "s3" {
    bucket = "wayofthesys2"
    key    = "bank-prod-argocd-front.tfstate"
    region = "us-east-2"
  }
}
