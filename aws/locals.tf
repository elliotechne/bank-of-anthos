locals {
  aws_provider_sa = "aws-provider"
  name            = var.eks_cluster_name 
  partition       = data.aws_partition.current.partition
  istio-repo      = "https://istio-release.storage.googleapis.com/charts"
  jetstack-repo   = "https://charts.jetstack.io"
  bookinfo-repo   = "https://evry-ace.github.io/helm-charts"
  argocd-repo     = "https://argoproj.github.io/argo-helm"
  efs-repo        = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  metrics-server  = "https://kubernetes-sigs.github.io/metrics-server"
  argocd_dex_google = yamlencode(
    {
      server = {
        config = {
          "admin.enabled" = "true"
          "url"           = "https://argocd.${var.domain_name[0]}"
          "dex.config" = yamlencode(
            {
              connectors = [
                {
                  id   = "google"
                  type = "oidc"
                  name = "Google"
                  config = {
                    issuer       = "https://accounts.google.com"
                    clientID     = var.argocd_oidc_client_id
                    clientSecret = var.argocd_oidc_client_secret
                  }
                  requestedScopes = [
                    "-openid",
                    "-profile",
                    "-email"
                  ]
                }
              ]
            }
          )
        }
      }
    }
  )
  argocd_dex_rbac = yamlencode(
    {
      server = {
        rbacConfig = {
          "policy.default" = "readOnly",
          "scopes"         = "[email]"
          "policy.csv" = replace(yamlencode(
            "g, autotune@contrasting.org, role:admin",
            ),
          "\"", "")
        }
      }
    }
  )

  egress_all_ports = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 65535
    }
  ]

  istio_ports = [
    {
      description = "Envoy admin port / outbound"
      from_port   = 15000
      to_port     = 15001
    },
    {
      description = "Debug port"
      from_port   = 15004
      to_port     = 15004
    },
    {
      description = "Envoy inbound"
      from_port   = 15006
      to_port     = 15006
    },
    {
      description = "HBONE mTLS tunnel port / secure networks XDS and CA services (Plaintext)"
      from_port   = 15008
      to_port     = 15010
    },
    {
      description = "XDS and CA services (TLS and mTLS)"
      from_port   = 15012
      to_port     = 15012
    },
    {
      description = "Control plane monitoring"
      from_port   = 15014
      to_port     = 15014
    },
    {
      description = "Webhook container port, forwarded from 443"
      from_port   = 15017
      to_port     = 15017
    },
    {
      description = "Merged Prometheus telemetry from Istio agent, Envoy, and application, Health checks"
      from_port   = 15020
      to_port     = 15021
    },
    {
      description = "DNS port"
      from_port   = 15053
      to_port     = 15053
    },
    {
      description = "Envoy Prometheus telemetry"
      from_port   = 15090
      to_port     = 15090
    },
    {
      description = "aws-load-balancer-controller"
      from_port   = 9443
      to_port     = 9443
    },
    {
      description = "http"
      from_port   = 80
      to_port     = 80
    },
    {
      description = "EFS"
      from_port   = 2049
      to_port     = 2049
    }
  ]

  ingress_rules = {
    for ikey, ivalue in local.istio_ports :
    "${ikey}_ingress" => {
      description = ivalue.description
      protocol    = "tcp"
      from_port   = ivalue.from_port
      to_port     = ivalue.to_port
      type        = "ingress"
      self        = true
    }
  }

  egress_rules = {
    for ekey, evalue in local.istio_ports :
    "${ekey}_egress" => {
      description = evalue.description
      protocol    = "tcp"
      from_port   = evalue.from_port
      to_port     = evalue.to_port
      type        = "egress"
      self        = true
    }
  }

  /*
  egress_all = {
    for ekey, evalue in local.egress_all_ports :
    "${ekey}_egress" => {
      description = evalue.description
      protocol    = "tcp"
      from_port   = evalue.from_port
      to_port     = evalue.to_port
      type        = "egress"
    }
  }
  */
}
