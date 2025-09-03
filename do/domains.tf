# Domain module call
module "domain" {
  source = "terraform-do-modules/domain/digitalocean"
  name   = "wayofthesys.com"

  records = {
    record1 = {
      type  = "A"
      name  = "@"
      value = "192.168.0.12"
    },
  }

}
