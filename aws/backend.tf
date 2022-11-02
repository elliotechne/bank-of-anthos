terraform {
    backend "s3" {
        bucket = "wayofthesys"
        key = "bank-prod.tfstate"
        region = "us-east-2"
    }
}
