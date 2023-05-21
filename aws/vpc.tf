module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "production"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  # database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.223.0/24"]
  # VERIFY IRL ENVIRONMENT
  map_public_ip_on_launch = true 
  enable_nat_gateway = true 
  enable_vpn_gateway = true
  create_igw         = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

