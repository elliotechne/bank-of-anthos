## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | terraform-do-modules/kubernetes/digitalocean | n/a |
| <a name="module_domain"></a> [domain](#module\_domain) | terraform-do-modules/domain/digitalocean | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-do-modules/vpc/digitalocean | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.boa](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster-issuer](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external-dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics-server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx-ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map_v1.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_ingress_v1.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.boa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.cert-manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.do_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.eab_hmac](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [digitalocean_kubernetes_cluster.boa](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_oidc_client_id"></a> [argocd\_oidc\_client\_id](#input\_argocd\_oidc\_client\_id) | ArgoCD OIDC Client ID | `string` | n/a | yes |
| <a name="input_argocd_oidc_client_secret"></a> [argocd\_oidc\_client\_secret](#input\_argocd\_oidc\_client\_secret) | ArgoCD OIDC Client Secret | `string` | n/a | yes |
| <a name="input_atlantis_container"></a> [atlantis\_container](#input\_atlantis\_container) | Name of the Atlantis container image to deploy. | `string` | `"runatlantis/atlantis:latest"` | no |
| <a name="input_atlantis_repo_whitelist"></a> [atlantis\_repo\_whitelist](#input\_atlantis\_repo\_whitelist) | n/a | `string` | `"github.com/elliotechne/bank-of-anthos"` | no |
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | n/a | `string` | n/a | yes |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | n/a | `string` | n/a | yes |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | n/a | `string` | `"bankofanthos"` | no |
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | n/a | `map(string)` | <pre>{<br/>  "createCustomResource": "true",<br/>  "installCRDs": "true"<br/>}</pre> | no |
| <a name="input_costcenter"></a> [costcenter](#input\_costcenter) | n/a | `string` | `"myteam"` | no |
| <a name="input_do_k8s_name"></a> [do\_k8s\_name](#input\_do\_k8s\_name) | Digital Ocean Kubernetes cluster name (e.g. `k8s-do`) | `string` | `"k8s-do"` | no |
| <a name="input_do_k8s_node_type"></a> [do\_k8s\_node\_type](#input\_do\_k8s\_node\_type) | Digital Ocean Kubernetes default node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM) | `string` | `"s-1vcpu-2gb"` | no |
| <a name="input_do_k8s_nodepool_name"></a> [do\_k8s\_nodepool\_name](#input\_do\_k8s\_nodepool\_name) | Digital Ocean Kubernetes additional node pool name (e.g. `k8s-do-nodepool`) | `string` | `"k8s-nodepool"` | no |
| <a name="input_do_k8s_nodepool_size"></a> [do\_k8s\_nodepool\_size](#input\_do\_k8s\_nodepool\_size) | Digital Ocean Kubernetes additional node pool size (e.g. `3`) | `number` | `2` | no |
| <a name="input_do_k8s_nodepool_type"></a> [do\_k8s\_nodepool\_type](#input\_do\_k8s\_nodepool\_type) | Digital Ocean Kubernetes additional node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM) | `string` | `"s-1vcpu-2gb"` | no |
| <a name="input_do_k8s_nodes"></a> [do\_k8s\_nodes](#input\_do\_k8s\_nodes) | Digital Ocean Kubernetes default node pool size (e.g. `2`) | `number` | `2` | no |
| <a name="input_do_k8s_pool_name"></a> [do\_k8s\_pool\_name](#input\_do\_k8s\_pool\_name) | Digital Ocean Kubernetes default node pool name (e.g. `k8s-do-nodepool`) | `string` | `"k8s-mainpool"` | no |
| <a name="input_do_region"></a> [do\_region](#input\_do\_region) | Digital Ocean region (e.g. `fra1` => Frankfurt) | `string` | `"nyc3"` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | Digital Ocean Personal access token | `string` | `""` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | domain to use for argo and atlantis | `list` | <pre>[<br/>  "wayofthesys.com"<br/>]</pre> | no |
| <a name="input_gh_username"></a> [gh\_username](#input\_gh\_username) | n/a | `string` | n/a | yes |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | n/a | `string` | `"elliotechne/bank-of-anthos"` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | le email | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"boa"` | no |
| <a name="input_package_registry_pat"></a> [package\_registry\_pat](#input\_package\_registry\_pat) | n/a | `string` | n/a | yes |
| <a name="input_sslcom_hmac_key"></a> [sslcom\_hmac\_key](#input\_sslcom\_hmac\_key) | n/a | `string` | n/a | yes |
| <a name="input_sslcom_keyid"></a> [sslcom\_keyid](#input\_sslcom\_keyid) | n/a | `string` | n/a | yes |
| <a name="input_sslcom_private_hmac_key"></a> [sslcom\_private\_hmac\_key](#input\_sslcom\_private\_hmac\_key) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
