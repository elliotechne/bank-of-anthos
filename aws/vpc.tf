module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "prod-use-2"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
  public_subnets  = ["10.0.105.0/24", "10.0.106.0/24", "10.0.107.0/24"]
  # database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.223.0/24"]
  # VERIFY IRL ENVIRONMENT
  map_public_ip_on_launch = true 
  enable_nat_gateway = false 
  enable_vpn_gateway = true
  create_igw         = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

