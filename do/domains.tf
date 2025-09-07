# Domain module call
module "domain" {
  source = "terraform-do-modules/domain/digitalocean"
  name   = "wayofthesys.com"
}

