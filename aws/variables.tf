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
  default     = ["wayofthesys.org"]
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_user" {
  description = "GitHub User"
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

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "prod"
}

variable "aws_partition_id" {
  description = "AWS Partition ID"
  type        = string
  default     = "bankofanthos"
}

variable "additional_irsa_policies" {
  description = "AWS Partition ID"
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}

variable "crossplane_region" {
  description = "Region to host Crossplane Infra"
  type        = string
  default     = "us-east-2"
}

variable "crossplane_s3_bucket" {
  description = "S3 Bucket For Crossplane TF Backend"
  type        = string
  default     = "wayofthesys"
}

variable "crossplane_tfstate_key" {
  description = "TFState Key For Crossplane TF Backend"
  type        = string
  default     = "crossplane-prod.tfstate"
}

variable "crossplane_eks_cluster_name" {
  description = "Crossplane EKS Cluster Name"
  type        = string
  default     = "BOA"
}

