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
