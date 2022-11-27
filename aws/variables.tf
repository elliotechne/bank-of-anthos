variable "region" {
  description = "The region where to provision resources"
  type        = string
}

variable "zerossl_eab_key_id" {
  description = "ZeroSSL eab key id"
  type        = string
}

variable "zerossl_eab_hmac_key" {
  description = "ZeroSSL eab hmac key"
  type        = string
}

variable "zerossl_email" {
  description = "ZeroSSL email"
  type        = string
}

variable "argocd_oidc_client_id" {
  description = "ArgoCD OIDC Client ID"
  type        = string
}

variable "argocd_oidc_client_secret" {
  description = "ArgoCD OIDC Client Secret"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name"
  type        = list(any)
  default     = ["wayofthesys.com"]
}

variable "externaldns_secret_key" {
  description = "ExternalDNS Secret Key"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_user" {
  description = "GitHub User"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes Namespace name"
  type        = string
}

variable "create_kubernetes_namespace" {
  description = "Should the module create the namespace"
  type        = bool
  default     = true
}

variable "create_kubernetes_service_account" {
  description = "Should the module create the Service Account"
  type        = bool
  default     = true
}

variable "kubernetes_service_account" {
  description = "Kubernetes Service Account Name"
  type        = string
}

variable "kubernetes_svc_image_pull_secrets" {
  description = "list(string) of kubernetes imagePullSecrets"
  type        = list(string)
  default     = []
}

variable "irsa_iam_policies" {
  type        = list(string)
  description = "IAM Policies for IRSA IAM role"
  default     = []
}

variable "irsa_iam_role_name" {
  type        = string
  description = "IAM role name for IRSA"
  default     = "crossplane-irsa"
}

variable "irsa_iam_role_path" {
  description = "IAM role path for IRSA roles"
  type        = string
  default     = "/"
}

variable "irsa_iam_permissions_boundary" {
  description = "IAM permissions boundary for IRSA roles"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}
