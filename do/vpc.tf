resource "digitalocean_vpc" "production" { 
  name     = "boa"
  region   = "nyc3"
  ip_range = "10.10.10.0/24"
}

module "vpc" {
  source      = "terraform-do-modules/vpc/digitalocean"
  version     = "1.0.0"
  name        = local.name
  environment = local.environment
  region      = local.region
  ip_range    = "10.0.0.0/16"
}

