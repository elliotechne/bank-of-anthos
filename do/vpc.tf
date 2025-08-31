resource "digitalocean_vpc" "production" {
  name     = "boa"
  region   = "nyc3"
  ip_range = "10.10.10.0/24"
}

// test
