terraform {
  backend "s3" {
    bucket = "wayofthesys2"
    key    = "bank-prod-helm.tfstate"
    region = "us-east-2"
  }
}
