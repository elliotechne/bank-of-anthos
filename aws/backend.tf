terraform {
    backend "s3" {
        bucket = "wayofthesys"
        key = "terraform.tfstate"
        region = "us-east-2"
    }
}
