terraform {
  backend "s3" {
    bucket = "wayofthesys"
    key    = "env:/production/crossplane-prod.tfstate"
    region = "us-east-2"
  }
}
