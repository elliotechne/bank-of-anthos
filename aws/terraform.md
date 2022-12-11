## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.45 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.45.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.16.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_provider_irsa"></a> [aws\_provider\_irsa](#module\_aws\_provider\_irsa) | git::https://github.com/autotune/terraform-aws-fully-loaded-eks-cluster.git//modules/irsa | n/a |
| <a name="module_cluster"></a> [cluster](#module\_cluster) | terraform-aws-modules/rds-aurora/aws | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | cloudposse/efs/aws | 0.32.7 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.27 |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | git::https://github.com/lablabs/terraform-aws-eks-external-dns | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_iam_policy.aws_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.node_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_rds_global_cluster.bsee](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_route53_zone.wayofthesys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_security_group_rule.allow_sidecar_injection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.aws-load-balancer-controller](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.bsee](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.cluster-issuer](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.crossplane-aws](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.crossplane-config](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.crossplane-terraform](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.crossplane-workspaces](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.efs](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.istio-base](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.istio-cni](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.istio-ingress](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.metrics-server](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [kubernetes_manifest.argocd-gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.argocd_virtualservice](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.certificate_argo](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.cert-manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.crossplane-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.external-dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_persistent_volume.bsee](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume) | resource |
| [kubernetes_secret.argocd-tls](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.external-dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.git-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.terraform-vars](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.wayofthesys-tls](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.zerossl_eab_hmac_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.zerossl_eab_key_id](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_storage_class.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [tls_cert_request.request](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.argocd](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_irsa_policies"></a> [additional\_irsa\_policies](#input\_additional\_irsa\_policies) | AWS Partition ID | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_argocd_oidc_client_id"></a> [argocd\_oidc\_client\_id](#input\_argocd\_oidc\_client\_id) | ArgoCD OIDC Client ID | `string` | n/a | yes |
| <a name="input_argocd_oidc_client_secret"></a> [argocd\_oidc\_client\_secret](#input\_argocd\_oidc\_client\_secret) | ArgoCD OIDC Client Secret | `string` | n/a | yes |
| <a name="input_aws_partition_id"></a> [aws\_partition\_id](#input\_aws\_partition\_id) | AWS Partition ID | `string` | `"bankofanthos"` | no |
| <a name="input_crossplane_eks_cluster_name"></a> [crossplane\_eks\_cluster\_name](#input\_crossplane\_eks\_cluster\_name) | Crossplane EKS Cluster Name | `string` | `"BOA"` | no |
| <a name="input_crossplane_region"></a> [crossplane\_region](#input\_crossplane\_region) | Region to host Crossplane Infra | `string` | `"us-east-2"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Primary domain name | `list(any)` | <pre>[<br>  "wayofthesys.com"<br>]</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | EKS Cluster Name | `string` | `"production"` | no |
| <a name="input_externaldns_secret_key"></a> [externaldns\_secret\_key](#input\_externaldns\_secret\_key) | ExternalDNS Secret Key | `string` | n/a | yes |
| <a name="input_github_pat"></a> [github\_pat](#input\_github\_pat) | GitHub Personal Access Token | `string` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | GitHub User | `string` | n/a | yes |
| <a name="input_irsa_iam_permissions_boundary"></a> [irsa\_iam\_permissions\_boundary](#input\_irsa\_iam\_permissions\_boundary) | IAM permissions boundary for IRSA roles | `string` | `""` | no |
| <a name="input_irsa_iam_policies"></a> [irsa\_iam\_policies](#input\_irsa\_iam\_policies) | IAM Policies for IRSA IAM role | `list(string)` | `[]` | no |
| <a name="input_irsa_iam_role_name"></a> [irsa\_iam\_role\_name](#input\_irsa\_iam\_role\_name) | IAM role name for IRSA | `string` | `"crossplane-irsa"` | no |
| <a name="input_irsa_iam_role_path"></a> [irsa\_iam\_role\_path](#input\_irsa\_iam\_role\_path) | IAM role path for IRSA roles | `string` | `"/"` | no |
| <a name="input_kubernetes_svc_image_pull_secrets"></a> [kubernetes\_svc\_image\_pull\_secrets](#input\_kubernetes\_svc\_image\_pull\_secrets) | list(string) of kubernetes imagePullSecrets | `list(string)` | `[]` | no |
| <a name="input_rds_bsee_password"></a> [rds\_bsee\_password](#input\_rds\_bsee\_password) | RDS BSEE Password | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where to provision resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| <a name="input_zerossl_eab_hmac_key"></a> [zerossl\_eab\_hmac\_key](#input\_zerossl\_eab\_hmac\_key) | ZeroSSL eab hmac key | `string` | n/a | yes |
| <a name="input_zerossl_eab_key_id"></a> [zerossl\_eab\_key\_id](#input\_zerossl\_eab\_key\_id) | ZeroSSL eab key id | `string` | n/a | yes |
| <a name="input_zerossl_email"></a> [zerossl\_email](#input\_zerossl\_email) | ZeroSSL email | `string` | n/a | yes |

## Outputs

No outputs.
