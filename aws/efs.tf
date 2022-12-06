module "efs" {
  count  = 0
  source = "cloudposse/efs/aws"
  depends_on = [helm_release.efs]
  # Cloud Posse recommends pinning every module to a specific version
  version     = "0.32.7"

  namespace = "default"
  stage     = "prod"
  name      = "bsee"
  region    = "us-east-2"
  vpc_id    = module.vpc.vpc_id
  subnets   = module.vpc.public_subnets
  zone_id   = [aws_route53_zone.wayofthesys.zone_id]

  allowed_security_group_ids = [module.eks.cluster_security_group_id]
}

resource "aws_efs_file_system_policy" "policy" {
  count          = 0
  file_system_id = module.efs[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "EFS01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${module.efs[0].arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}
