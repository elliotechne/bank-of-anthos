# Port needed to solve the error
# Internal error occurred: failed calling 
# webhook "namespace.sidecar-injector.istio.io": failed to 
# call webhook: Post "https://istiod.istio-system.svc:443/inject?timeout=10s": # context deadline exceeded
resource "aws_security_group_rule" "allow_sidecar_injection" {
  description = "Webhook container port, From Control Plane"
  protocol    = "tcp"
  type        = "ingress"
  from_port   = 15017
  to_port     = 15017

  security_group_id        = module.eks.node_security_group_id
  source_security_group_id = module.eks.cluster_primary_security_group_id
}
