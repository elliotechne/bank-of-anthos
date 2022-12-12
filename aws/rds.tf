resource "aws_rds_global_cluster" "bsee" {
  count                     = 1
  global_cluster_identifier = "bsee"
  engine                    = "aurora-postgresql"
  engine_version            = "11.12"
  database_name             = "bsee"
  storage_encrypted         = true
}

module "cluster" {
  count = 0
  source  = "terraform-aws-modules/rds-aurora/aws"

  name           = "bsee"
  engine         = aws_rds_global_cluster.bsee.engine
  database_name  = aws_rds_global_cluster.bsee.database_name
  engine_version = aws_rds_global_cluster.bsee.engine_version
  instance_class = "db.r6g.large"
  instances = { for i in range(2) : i => {} }

  vpc_id  = module.vpc.vpc_id

  allowed_security_groups = [module.security_group.security_group_id]
  allowed_cidr_blocks     = ["10.0.0.0/16"]

  master_username = "bsee"
  master_password = var.rds_bsee_password 
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_subnet_group_name   = module.vpc.database_subnet_group_name
  create_db_subnet_group = false
  create_security_group  = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "security_group" {
  count   = 1
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "rds"
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}
