terraform {
  backend "s3" {
    bucket = "wayofthesys2"
    key    = "bank-prod.tfstate"
    region = "us-east-2"
  }
}
