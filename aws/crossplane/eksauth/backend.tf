terraform {
  backend "s3" {
    bucket = "wayofthesys2"
    key    = "env:/production/crossplane-auth.tfstate"
    region = "us-east-2"
  }
}
