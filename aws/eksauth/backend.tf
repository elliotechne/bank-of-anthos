terraform {
  backend "s3" {
    bucket = "wayofthesys2"
    key    = "bank-dev-auth.tfstate"
    region = "us-east-2"
  }
}
