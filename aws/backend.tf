terraform {
  backend "s3" {
    bucket = "wayofthesys2"
    key    = "bank-prod-2.tfstate"
    region = "us-east-2"
  }
}
