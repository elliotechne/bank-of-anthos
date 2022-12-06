module "efs" {
  source = "cloudposse/efs/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version     = "0.32.7"

  namespace = "default"
  stage     = "prod"
  name      = "bsee"
  region    = "us-east-2"
  vpc_id    = module.vpc.vpc_id
  subnets   = [module.vpc.private_subnets, module.vpc.public_subnets]
  zone_id   = [aws_route53_zone.wayofthesys.zone_id]

  allowed_security_group_ids = [module.eks.cluster_security_group_id]
}
