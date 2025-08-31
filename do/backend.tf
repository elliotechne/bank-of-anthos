terraform {
  backend "s3" {
    bucket                      = "bankofanthos"
    key                         = "atlantis.tfstate"
    region                      = "us-east-1"  # Required but ignored by DO Spaces
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
